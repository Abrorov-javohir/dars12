import 'package:dars72_location/screen/home_screen.dart';
import 'package:dars72_location/service/location_service.dart';
import 'package:dars72_location/service/travel_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider<FirebaseProductService>(
            create: (_) => FirebaseProductService()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
