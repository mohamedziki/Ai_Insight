import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../firebase_options.dart';
import 'dart:async';

import 'connection_checker.dart';
import 'home_screen.dart';


/*class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
 void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.black,
          size: 100.0,
        ),
      ),
    );
  }
}*/
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  // wait();
  }
  /*Future<void> wait() async{

    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Future<void> fetchData() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await context.read<List<Article>>();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }*/

  Future<void> _checkInternetConnection() async {
    bool hasInternet = await ConnectionChecker.isInternetAvailable();
    if (!hasInternet) {
      // We need to use Future.microtask because we can't show a dialog in initState
      Future.microtask(() => ConnectionChecker.showNoInternetDialog(context));
    }
    else if (hasInternet == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    //final articlesProvider = Provider.of<ArticlesProvider>(context);
    return Scaffold(
      body: SpinKitDoubleBounce(
        color: Colors.black,
        size: 100.0,
      ),
    );
  }
}

