import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class ConnectionChecker {
  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () async {
                Navigator.of(context).pop();
                bool hasInternet = await isInternetAvailable();
                if (!hasInternet) {
                  showNoInternetDialog(context);
                }
                else if (hasInternet == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}