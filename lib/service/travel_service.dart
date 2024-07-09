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
      return snapshot.docs.map((DocumentSnapshot doc) {
        return Travel.fromDocument(doc);
      }).toList();
    });
  }

  Future<void> addProduct(
      String imageUrl, String name, GeoPoint location, double rating) async {
    await _firestore.collection('travel').add(
      {
        'title': name,
        'photo': imageUrl,
        'rating': rating,
      },
    );
    notifyListeners();
  }

  Future<void> updateProduct(
      String id, String imageUrl, String name, GeoPoint location) async {
    await _firestore.collection('travel').doc(id).update(
      {
        'title': name,
        'photo': imageUrl,
      },
    );
    notifyListeners();
  }

  Future<void> deleteProduct(String id, String imageUrl) async {
    // Firestore documentni o'chirish
    await _firestore.collection('travel').doc(id).delete();

    // Firebase Storage'dan rasmni o'chirish
    final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await storageRef.delete();

    notifyListeners();
  }
}
