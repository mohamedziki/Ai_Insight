import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:climate_insight_ai/Componenets/Bottom_Navigation_Bar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  Future<void> showInAppReview() async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    } else {
      await InAppReview.instance.openStoreListing();
    }
  }

  final Uri mailtoUri = Uri(
    scheme: 'mailto',
    path: 'simoziki99@gmail.com',
    queryParameters: {
      'subject': '',
      'body': '',
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFfcb0f3), // Lighter blue
              Color(0xFF3d05dd),
              // Light Purple
              // Pinkish
            ],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            "settings",
            maxLines: 2,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(
        index: 2,
      ),
      body: ListView(
        padding: EdgeInsets.all(7),
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              padding:
                  const EdgeInsets.all(1), // Adjust border thickness here
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    // Adjust colors for desired shading
                    Color(0xFFfcb0f3), // Lighter blue
                    Color(0xFF3d05dd),
                  ],
                ),
              ),
              child: Container(
                // Inner container for the main button
                decoration: BoxDecoration(
                  color: const Color(0xFF0F152B),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Card(
                  surfaceTintColor: Color(0xFF0F152B),
                  color: Color(0xFF0F152B),


                  child: ListTile(
                    trailing: Icon(
                        color: Color(0xFF939DB6),
                        size: 20,
                        (Icons.arrow_forward_ios_rounded)),
                    contentPadding: EdgeInsets.all(10),
                    titleTextStyle: TextStyle(
                      color: Color(0xFF939DB6),
                      letterSpacing: 2,
                      fontSize: 17,
                      fontFamily: 'Playball',
                      fontWeight: FontWeight.w600,
                    ),
                    leading: const Icon(
                      Icons.email,
                      color: Color(0xFF939DB6),
                    ),
                    title: const Text('Contact Us'),
                    onTap: () async {
                      if (await canLaunchUrl(mailtoUri)) {
                        await launchUrl(mailtoUri);
                      } else {
                        throw 'Could not launch $mailtoUri';
                      }
                    },
                  ),
                ),
              )),

          SizedBox(
            height: 10,
          ),
          // ... Add other list tiles with similar structure
        ],
      ),
    );
  }
}
