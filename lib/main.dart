import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Componenets/OnBoarding.dart';
import 'package:climate_insight_ai/models/firebase_options.dart';
import 'package:climate_insight_ai/pages/home_screen.dart';
import 'models/fireStoreServices.dart';
import 'package:climate_insight_ai/models/Provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  bool showOnboarding = await _shouldShowOnboarding();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                ArticlesProviderAi(firestoreService: FirestoreService())),
      ],
      child: MyApp(showOnboarding: showOnboarding),
    ),
  );
}

Future<bool> _shouldShowOnboarding() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seen = prefs.getBool('seenOnboarding') ?? false;
  return !seen;
}

class MyApp extends StatelessWidget {
  final bool showOnboarding; // Add this property
  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        navigationBarTheme: const NavigationBarThemeData(
          height: 80.0,
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: 'Flutter Demo',
      home: showOnboarding ? OnboardingScreen() : HomeScreen(),
    );
  }
}