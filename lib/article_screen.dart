import 'dart:ui';
import 'package:climate_insight_ai/Gemini_AI_Insight.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:io' show Platform;
import 'CustomTag.dart';
import 'models/Firestore_Model.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;
  const ArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretchTriggerOffset: 320,
            forceMaterialTransparency: true,
            forceElevated: true,
            stretch: true,
            elevation: 0.0,
            leading: Container(
              margin: EdgeInsets.only(left: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(56.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    height: 56.0,
                    width: 56.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle),
                    child: IconButton(
                        iconSize: 20.0,
                        color: Colors.white,
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_outlined)),
                  ),
                ),
              ),
            ),
            leadingWidth: 80.0,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  padding: EdgeInsets.only(),
                  decoration: BoxDecoration(
                      color: Color(0xFF12141E),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                  child: Text(
                    'TEST BORDER RADIUS',
                    style: TextStyle(color: Colors.transparent),
                  ),
                  width: double.maxFinite,
                )),
            centerTitle: false,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              titlePadding: EdgeInsets.only(),
              centerTitle: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 21, right: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTag(children: [
                          Text(
                            widget.article.source!['name'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 8.0,
                                    fontFamily: 'HedvigLettersSerif',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ]),
                        CustomTag(children: [
                          Text(
                            _calculateTimeAgoText(
                                DateTime.now()
                                    .difference(widget.article.publishedAt)
                                    .inSeconds,
                                widget.article),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 8.0,
                                    fontFamily: 'HedvigLettersSerif',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ])
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          // Adjust colors for desired shading
                          Colors.black.withOpacity(1),
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 20),
                      child: Text(
                        widget.article.title!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.0,
                            wordSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              background: Image.network(
                widget.article.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15,left: 10, right: 10, bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(
                        1.5), // Adjust border thickness here
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          // Adjust colors for desired shading
                          Color(0xFF66C2FF), // Lighter blue
                          Color(0xFF337AFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      // Inner container for the main button
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F152B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: myCard(
                          surfaceTintColor: Color(0xFF0F152B),
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Summary',style: TextStyle(
                            fontSize: 30,
                            height: 1.4,
                            fontFamily: "DMSerifDisplay",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                          SizedBox(height: 8,),
                          Text(
                            "${widget.article.summary}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "OpenSans",
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF939DB6),
                            ),
                            textAlign: TextAlign.center  ),
                        ],
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 15,left: 10, right: 10, bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(
                        1.5), // Adjust border thickness here
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          // Adjust colors for desired shading
                          Color(0xFF66C2FF), // Lighter blue
                          Color(0xFF337AFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      // Inner container for the main button
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F152B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: myCard(
                          surfaceTintColor: Color(0xFF0F152B),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Consequenses',style: TextStyle(
                                fontSize: 30,
                                fontFamily: "DMSerifDisplay",
                                height: 1.4,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),),
                              SizedBox(height: 8,),
                              Text(
                                  "${widget.article.consequences}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "OpenSans",
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF939DB6),
                                  ),
                                  textAlign: TextAlign.center  ),
                            ],
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 15,left: 10, right: 10, bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(
                        1.5), // Adjust border thickness here
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          // Adjust colors for desired shading
                          Color(0xFF66C2FF), // Lighter blue
                          Color(0xFF337AFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      // Inner container for the main button
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F152B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: myCard(
                          surfaceTintColor: Color(0xFF0F152B),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Benefits Of Actions',style: TextStyle(
                                fontSize: 30,
                                height: 1.4,
                                fontFamily: "DMSerifDisplay",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),),
                              SizedBox(height: 8,),
                              Text(
                                  "${widget.article.benefitsOfAction}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "OpenSans",
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF939DB6),
                                  ),
                                  textAlign: TextAlign.center  ),
                            ],
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10,bottom: 10),
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse(widget.article.url)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                              1.0), // Adjust border thickness here
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                // Adjust colors for desired shading
                                Color(0xFF66C2FF), // Lighter blue
                                Color(0xFF337AFF),
                              ],
                            ),
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
                                  Text(
                                    "Read Article From Source",
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),],
            ),
          )
        ],
      ),
    );
  }
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
