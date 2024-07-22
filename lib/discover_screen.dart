import 'package:climate_insight_ai/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:climate_insight_ai/Bottom_Navigation_Bar.dart';
import 'package:provider/provider.dart';
import 'Image_Container.dart';
import 'models/Provider.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    final articlesProviderString = Provider.of<ArticlesProviderAi>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              iconSize: 30,
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          elevation: 3,
          automaticallyImplyLeading: false,
          title: Text(
            'Categories',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Playball',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottomNavigationBar: const NavBar(
          index: 1,
        ),
        body: ListWheelScrollView.useDelegate(
          useMagnifier: false,
          diameterRatio: 7.0,
          itemExtent: 250,
          childDelegate: ListWheelChildLoopingListDelegate(children: [
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Climate Change');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: 'images/Designer.png'),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Global Warming');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/_b79a234d-2feb-47d6-91b7-c8cab5727b71.jfif"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Greenhouse Gases');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/Designer (1).png"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Carbon Emissions');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/_57e5efa4-8dea-4005-9900-4b0fc0b72dd4.jfif"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Sea Level Rise');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/sea level rize.png"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Extreme Weather');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/_33a9f8a2-cd8b-4ed8-8089-602e8a3fc0a6.jfif"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Climate Policy');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/_105901c0-fd6f-404a-8bac-0a866a743351.jfif"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Renewable Energy');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/_fecc1a7d-b341-49ec-928a-76e5d7951b6b.jfif"),
            ),
            GestureDetector(
              onTap: () {
                articlesProviderString.changeKeyword('Electric Vehicles');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ImageContainerAsset(
                  showShadow: false,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  image: "images/_84ea7030-2e59-4d8c-a0e9-fe11dbaaedb4.jfif"),
            ),
          ]),
        ));
  }
}

class ImageContainerAsset extends StatelessWidget {
  const ImageContainerAsset({
    this.borderRadius = 0,
    this.padding,
    required this.width,
    required this.image,
    this.height = 130,
    this.child,
    this.margin,
    this.showShadow = false,
    super.key,
  });
  final double height;
  final double width;
  final String image;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(image: AssetImage("$image"), fit: BoxFit.fill),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
