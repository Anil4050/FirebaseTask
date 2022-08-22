import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'View/Screens/listUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseFirestore.instance;
  // await Firebase.initializeApp();

  // await firestoreOperation().getSliderData();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Color(0xFF607D8B),
    statusBarIconBrightness: Brightness.light, // For Android (dark icons)
    statusBarBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return Text('Please Check Your Internet Connection');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return listUser();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
