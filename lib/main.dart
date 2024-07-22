import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
 import 'models/fireStoreServices.dart';
 import 'package:climate_insight_ai/models/Provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );

   await FirebaseAppCheck.instance.activate(
     androidProvider: AndroidProvider.playIntegrity,
   );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticlesProviderAi(firestoreService: FirestoreService())),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        navigationBarTheme: const NavigationBarThemeData(
        height: 80.0,
          labelTextStyle: MaterialStatePropertyAll(TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
    ),),
      title: 'Flutter Demo',
      home: HomeScreen(),

    );
  }
}
