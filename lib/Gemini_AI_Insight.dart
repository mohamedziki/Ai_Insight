import 'package:climate_insight_ai/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CustomTag.dart';
import 'home_screen.dart';
import 'models/Firestore_Model.dart';
import 'models/Provider.dart';

class ImpactAnalysis extends StatelessWidget {
  // ... (Your existing variable declarations) ...
  final Article article;
  final String impact;
  final String degreeOfImpact;
  final String mostAffectedCountry;
  final String rippleEffect;
  final String urgencyDetail;
  final String responsibilityDetail;
  final String urgency;
  final String responsibility;
  const ImpactAnalysis({
    Key? key,
    required this.article,
    required this.impact,
    required this.degreeOfImpact,
    required this.mostAffectedCountry,
    required this.rippleEffect,
    required this.urgencyDetail,
    required this.responsibilityDetail,
    required this.urgency,
    required this.responsibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myCard(
      surfaceTintColor: Color(0xFF12141E),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Why does this matter?" section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF66C2FF), // Lighter blue
                      Color(0xFF337AFF), // Slightly darker blue
                    ],
                  ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    'Why does this matter ?',
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                getImpactIcon("$degreeOfImpact", getImpactColor("$impact")),
              ],
            ),
            Text(
              rippleEffect,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6D759D),
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Why this urgency ?'),
                getUrgencyIcon("$urgency"),
              ],
            ),
            Text(
              urgencyDetail,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6D759D),
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 8,
            ),
            _buildSectionHeader('Who needs to step up ? $responsibility'),
            Text(
              responsibilityDetail,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6D759D),
              ),
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                        1.0), // Adjust border thickness here
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.1), // Semi-transparent white border
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      // Inner container for the main button
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12141E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        height: 25.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ArticleScreen(article: article),
                                ),
                              ),
                              child: Text(
                                "Learn More",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 15.0,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for section headers (cleaner code)
  Widget _buildSectionHeader(String text) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF66C2FF), // Lighter blue
          Color(0xFF337AFF), // Slightly darker blue
        ],
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }
}

class myCard extends StatelessWidget {
  myCard({
    required this.child,
    required this.surfaceTintColor,
  });
  late final Widget child;
  late final Color surfaceTintColor;
  @override
  Widget build(BuildContext context) {
    return Card(
      // Added a Card widget for a clean look
      elevation: 4,
      child: child,
      shadowColor: Colors.black,
      surfaceTintColor: surfaceTintColor , //Color(0xFF12141E)
      color: surfaceTintColor,//Color(0xFF12141E)
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
