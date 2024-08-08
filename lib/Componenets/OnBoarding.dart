import 'package:climate_insight_ai/Componenets/CustomTag.dart';
import 'package:climate_insight_ai/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 5,
      width: isActive ? 30.0 : 15,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF3d05dd) : Color(0xFF7B809D),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  _buildOnboardingPage(
                      "images/kn.jpg",
                      ' Understand Climate Change',
                      ' AI-powered insights on global warming, renewable energy News, and more.'),
                  _buildOnboardingPage('images/onboarding 1 .jpg', ' Cut Through the Noise',
                      'Get clear summaries and AI analysis of the latest climate news.'),
                  _buildOnboardingPage('images/onboarding 4.jpg', 'Make a Difference',
                      'Discover solutions, Stay ahead of climate trends, and join the fight for our planet.'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(3),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () async {
                  if (_currentPage == 2) {
                    OnboardingInfo.markOnboardingSeen();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {

                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFfcb0f3), // Lighter blue
                        Color(0xFF3d05dd),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _currentPage == 2 ? 'Get Started' : 'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,),
                )
              ),
              ),
    SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
  Widget _buildOnboardingPage(
      String imagePath, String title, String description) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(imagePath),
              height: 300.0,
              width: 300.0,
            ),
          ),
          SizedBox(height: 30.0),
          ShaderMask(

            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                const LinearGradient(
                  colors: [
                    Color(0xFFfcb0f3), // Lighter blue
                    Color(0xFF3d05dd),

                  ],
                ).createShader(Rect.fromLTWH(
                    0, 0, bounds.width, bounds.height)),
            child:  Text(
                 title ,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

          ),
          SizedBox(height: 15.0),
          Text (
            description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D759D),
            ),
            textAlign: TextAlign.center,
  ),
        ],
      ),
    );
  }
}

class OnboardingInfo {
  static Future<bool> shouldShowOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seenOnboarding') ?? false;
    return !seen;
  }

  static void markOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }
}
