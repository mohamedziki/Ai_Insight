import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:provider/provider.dart';
import 'Bottom_Navigation_Bar.dart';
import 'CustomTag.dart';
import 'Gemini_AI_Insight.dart';
import 'Image_Container.dart';
import 'first_screen.dart';
import 'models/Firestore_Model.dart';
import 'models/Provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isloadMore = false;
  final InfiniteScrollController _infiniteController = InfiniteScrollController(
    initialScrollOffset: 0.0,
  );
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: const NavBar(
          index: 0,
        ),
        /*appBar: AppBar(
          elevation: 5,
          automaticallyImplyLeading:true,
          backgroundColor: Colors.transparent,
        ),*/
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            slivers: [
              SliverList(
                delegate:
                    SliverChildBuilderDelegate(childCount: 1, (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 15,bottom: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ShaderMask(
                                // Apply gradient here
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF4E54C8), // Blueish
                                    Color(0xFF8F94FB), // Light Purple
                                    Color(0xFFDA627D), // Pinkish
                                  ],
                                ).createShader(Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height)),
                                child: const Text(
                                  "Let's Save Our Planet Together",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                categoryName = 'Climate Change';
                              });
                            },
                            child: CustomTag(
                                backgroundColor: Colors.blueAccent,
                                children: [
                                  Text(
                                    'Climate Change',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 13.0,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                  ),
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                categoryName = 'Electric Vehicles';
                              });
                            },
                            child: CustomTag(
                                backgroundColor: Colors.blueAccent,
                                children: [
                                  Text(
                                    "Electric Vehicles",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 13.0,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                  ),
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                categoryName = 'Global Warming';
                              });
                            },
                            child: CustomTag(
                                backgroundColor: Colors.blueAccent,
                                children: [
                                  Text(
                                    "Global Warming",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 13.0,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                  ),
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                categoryName = 'Greenhouse Gases';
                              });
                            },
                            child: CustomTag(
                                backgroundColor: Colors.blueAccent,
                                children: [
                                  Text(
                                    "Global Warming",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 13.0,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                categoryName = 'Carbon Emissions';
                              });
                            },
                            child: CustomTag(
                                backgroundColor: Colors.blueAccent,
                                children: [
                                  Text(
                                    "Global Warming",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 13.0,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                categoryName = 'Sea Level Rise';
                              });
                            },
                            child: CustomTag(
                                backgroundColor: Colors.blueAccent,
                                children: [
                                  Text(
                                    "Global Warming",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 13.0,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),*/
                      BreakingNews(),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 13, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              // Apply gradient here
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF4E54C8), // Blueish
                                  Color(0xFF8F94FB), // Light Purple
                                  Color(0xFFDA627D), // Pinkish
                                ],
                              ).createShader(Rect.fromLTWH(
                                  0, 0, bounds.width, bounds.height)),
                              child: const Text(
                                'Gemini Ai Insight',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<ArticlesProviderAi>(
                        builder: (context, articlesProvider, child) {
                          if (articlesProvider.isFetching) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            final selectedArticle =
                                articlesProvider.selectedArticle;
                            if (selectedArticle != null) {
                              return ImpactAnalysis(
                                article: selectedArticle,
                                responsibility:
                                    selectedArticle?.responsibility ?? '',
                                urgency: selectedArticle?.urgency ?? '',
                                responsibilityDetail:
                                    selectedArticle?.responsibilityDetail ?? '',
                                urgencyDetail:
                                    selectedArticle?.urgencyDetail ?? '',
                                rippleEffect:
                                    selectedArticle?.rippleEffect ?? '',
                                impact: selectedArticle?.impact ?? '',
                                degreeOfImpact:
                                    selectedArticle?.degreeOfImpact ?? '',
                                mostAffectedCountry:
                                    selectedArticle?.mostAffectedCountry ?? '',
                              );
                            } else {
                              return const Center(
                                  child: Text(
                                'No article selected.',
                                style: TextStyle(color: Colors.black),
                              ));
                            }
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HottestNews extends StatelessWidget {
  HottestNews({
    required this.image,
    required this.title,
    required this.hoursAgo,
    required this.source,
    required this.urgency,
    required this.responsibility,
    this.degreeOfImpact,
    this.impact,
    this.region,
    required this.mostAffectedCountry,
  });

  late final String image;
  late final String title;
  late final String source;
  late final String hoursAgo;
  late final String? urgency;
  late final String responsibility;
  late final String? impact;
  late final String? degreeOfImpact;
  late final String? region;
  late final String? mostAffectedCountry;
  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.30,
      image: image,
      padding: const EdgeInsets.only(
        top: 17.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTag( children: [
                  Text(
                    source,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 13.0,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  // Adjust colors for desired shading
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      //  Icon(Icons.flag,color: Colors.blueAccent,size: 20,),
                      Expanded(
                        child: Text(
                          "$responsibility responsibility",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            wordSpacing: 2,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontSize: 17,
                          wordSpacing: 2,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          height: 1.30,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getImpactIcon(
                          "$degreeOfImpact", getImpactColor("$impact")),
                      Text(
                        "$mostAffectedCountry",
                        style: TextStyle(
                          fontSize: 12,
                          wordSpacing: 2,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          height: 1.30,
                          color: Colors.white,
                        ),
                      ),
                      getUrgencyIcon("$urgency")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getImpactColor(String impact) {
  // Define a map to associate impact levels with colors
  Map<String, Color> impactColors = {
    'Positive': Colors.green,
    'positive': Colors.green,
    'no impact': Colors.grey,
    'No impact': Colors.grey,
    'Mixed': Colors.yellow,
    'mixed': Colors.yellow,
    'Negative': Colors.red,
    'negative': Colors.red,
  };

  // Return the color based on the impact level (or a default color)
  return impactColors[impact] ?? Colors.grey;
}

Widget getImpactIcon(String impactLevel, Color color) {
  // Determine how many circles to fill based on impact level
  int filledCircles = {'Low': 1, 'Medium': 2, 'High': 3}[impactLevel] ?? 0;

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(3, (index) {
      // Check if this circle should be filled or outlined
      bool isFilled = index < filledCircles;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2), // Spacing
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1), // Always outlined
          color: isFilled ? color : Colors.transparent, // Fill conditionally
        ),
        child: SizedBox(
          width: 8, // Adjust circle size as needed
          height: 8,
        ),
      );
    }),
  );
}

Widget getUrgencyIcon(String urgency) {
  Map<String, IconData> actionIcons = {
    'Immediate Action': Icons.warning_rounded,
    'Urgent Response': Icons.notification_important_rounded,
    'Long-Term Action': Icons.edit_calendar_rounded,
    'No Action required': Icons.check_circle_outline_rounded,
  };

  // Get the icon based on the actionType, default to an error icon
  IconData icon = actionIcons[urgency] ?? Icons.error;
  return Icon(icon,
      color: getUrgencyColor(urgency), size: 20); // Adjust icon size as need
}

Color getUrgencyColor(String urgency) {
  // Define a map to associate impact levels with colors
  Map<String, Color> impactColors = {
    'Immediate Action': Colors.yellow,
    'Urgent Response': Colors.red,
    'Long-Term Action': Colors.blue,
    'No Action Required': Colors.grey,
  };

  // Return the color based on the impact level (or a default color)
  return impactColors[urgency] ?? Colors.grey;
}

String _calculateTimeAgoText(int differenceInSeconds, Article article) {
  if (differenceInSeconds < 60) {
    return '$differenceInSeconds seconds ago';
  } else if (differenceInSeconds < 60 * 60) {
    return '${differenceInSeconds ~/ 60} minutes ago';
  } else if (differenceInSeconds < 24 * 60 * 60) {
    return '${differenceInSeconds ~/ (60 * 60)} hours ago';
  } else {
    return '${DateFormat('dd MMM').format(article.publishedAt)} ';
  }
}

