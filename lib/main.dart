import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:apploja/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC77HT1xxENxYNxz4YpbzR4Ao-C6oLzxnY",
          authDomain: "apploja-flutter.firebaseapp.com",
          projectId: "apploja-flutter",
          storageBucket: "apploja-flutter.appspot.com",
          messagingSenderId: "328300001606",
          appId: "1:328300001606:web:61c49e460094f5b570cd47"));

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  print('Initialized default app $app');

  //await dotenv.load(fileName: "assets/.env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const primaryColor = Colors.indigo;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Crud Firestore",

      theme: ThemeData(
          primarySwatch: MyApp.primaryColor,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.lightBlue)),

      initialRoute: '/',

      //Gerador de rotas - navegação entre as telas

      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
