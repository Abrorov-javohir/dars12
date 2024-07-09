import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars72_location/model/travel.dart';
import 'package:dars72_location/screen/widget/product_card.dart';
import 'package:dars72_location/service/travel_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData? _currentLocation;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await _location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });
  }

  Future<String?> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(File(pickedFile.path));
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    }
    return null;
  }

  Future<void> _addProduct(BuildContext context, String imageUrl) async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available')),
      );
      return;
    }

    final travelService =
        Provider.of<FirebaseProductService>(context, listen: false);
    await travelService.addProduct(
      imageUrl,
      'New Travel',
      GeoPoint(_currentLocation!.latitude!, _currentLocation!.longitude!),
      5.0,
    );
  }

  void _showEditDialog(
      BuildContext context, Travel product, String? newImageUrl) {
    final titleController = TextEditingController(text: product.title);
    String updatedImageUrl = newImageUrl ?? product.photo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Travel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              Image.network(updatedImageUrl, height: 100, width: 100),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final newUrl =
                          await _pickImage(context, ImageSource.camera);
                      if (newUrl != null) {
                        updatedImageUrl = newUrl;
                        Navigator.of(context).pop();
                        _showEditDialog(context, product, updatedImageUrl);
                      }
                    },
                    icon: const Icon(Icons.camera),
                  ),
                  IconButton(
                    onPressed: () async {
                      final newUrl =
                          await _pickImage(context, ImageSource.gallery);
                      if (newUrl != null) {
                        updatedImageUrl = newUrl;
                        Navigator.of(context).pop();
                        _showEditDialog(context, product, updatedImageUrl);
                      }
                    },
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final travelService =
                    Provider.of<FirebaseProductService>(context, listen: false);
                await travelService.updateProduct(
                  product.id,
                  updatedImageUrl,
                  titleController.text,
                  product.location,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(BuildContext context, Travel product) async {
    final travelService =
        Provider.of<FirebaseProductService>(context, listen: false);
    await travelService.deleteProduct(product.id, product.photo);
  }

  @override
  Widget build(BuildContext context) {
    final travelService = Provider.of<FirebaseProductService>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
        title: _currentLocation != null
            ? Text(
                'Lat: ${_currentLocation!.latitude}, Lon: ${_currentLocation!.longitude}')
            : const Text('Getting location...'),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
                child: StreamBuilder<List<Travel>>(
              stream: travelService.getProducts(),
              builder: (context, snapshot) {
                print(
                    'StreamBuilder ConnectionState: ${snapshot.connectionState}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return const Center(child: Text('Error loading products'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No products found');
                  return const Center(child: Text('No products found'));
                }
                final products = snapshot.data!;
                print('Found ${products.length} products');
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Stack(
                      children: [
                        ProductCard(product: product),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Column(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteProduct(context, product),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditDialog(context, product, null);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: () async {
              final imageUrl = await _pickImage(context, ImageSource.gallery);
              if (imageUrl != null) {
                await _addProduct(context, imageUrl);
              }
            },
            child: const Icon(Icons.photo_library),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: () async {
              final imageUrl = await _pickImage(context, ImageSource.camera);
              if (imageUrl != null) {
                await _addProduct(context, imageUrl);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
