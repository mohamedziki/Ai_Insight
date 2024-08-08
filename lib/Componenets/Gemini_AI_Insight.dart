import 'package:climate_insight_ai/pages/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CustomTag.dart';
import '../pages/home_screen.dart';
import '../models/Firestore_Model.dart';
import '../models/Provider.dart';


class ImpactAnalysis extends StatelessWidget {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFfcb0f3),
                      Color(0xFF3d05dd),
                    ],
                  ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    '$degreeOfImpact $impact Impact',
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
                _buildSectionHeader('$urgency'),
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
            _buildSectionHeader('$responsibility responsibility '),
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
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
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

  Widget _buildSectionHeader(String text) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFFfcb0f3),
          Color(0xFF3d05dd),
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

      elevation: 4,
      child: child,
      shadowColor: Colors.black,
      surfaceTintColor: surfaceTintColor ,
      color: surfaceTintColor,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
