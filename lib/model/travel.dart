import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Travel {
  String id;
  String title;
  String photo;
  GeoPoint location;

  Travel({
    required this.id,
    required this.title,
    required this.photo,
    required this.location,
  });
  factory Travel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Travel(
      id: doc.id,
      title: data['title'] as String,
      photo: data['photo'] as String,
      location: data['location'] as GeoPoint,
    );
  }
}
