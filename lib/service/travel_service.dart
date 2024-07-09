import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars72_location/model/travel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseProductService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Travel>> getProducts() {
    return _firestore
        .collection('travel')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((DocumentSnapshot doc) {
            try {
              return Travel.fromDocument(doc);
            } catch (e) {
              print('Error parsing document ${doc.id}: $e');
              return null;
            }
          })
          .where((travel) => travel != null)
          .cast<Travel>()
          .toList();
    }).handleError((error) {
      print('Error getting products: $error');
    });
  }

  Future<void> addProduct(
      String imageUrl, String name, GeoPoint location, double rating) async {
    try {
      await _firestore.collection('travel').add({
        'title': name,
        'photo': imageUrl,
        'rating': rating,
        'location': location, // Make sure to include location if needed
      });
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(
      String id, String imageUrl, String name, GeoPoint location) async {
    try {
      await _firestore.collection('travel').doc(id).update({
        'title': name,
        'photo': imageUrl,
        'location': location, // Ensure location is updated if necessary
      });
      notifyListeners();
    } catch (e) {
      print('Error updating product $id: $e');
    }
  }

  Future<void> deleteProduct(String id, String imageUrl) async {
    try {
      // Firestore documentni o'chirish
      await _firestore.collection('travel').doc(id).delete();

      // Firebase Storage'dan rasmni o'chirish
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      notifyListeners();
    } catch (e) {
      print('Error deleting product $id: $e');
    }
  }
}
