import 'package:flutter/material.dart';
import 'loading_screen.dart';


/// Routes Names
const String homescreen = 'Home';
const String discoverscreen = 'Discover';
const String profilescreen = 'profile';
const String articlescreen = 'article';
const String loadingscreen = 'loading';
const String viewAll = 'viewAll';
/// Routes Class
Route<dynamic> controller (RouteSettings settings){
  switch (settings.name){
  /*case homescreen:
      return MaterialPageRoute(builder: (context) => HomeScreen());*/
    case loadingscreen:
      return MaterialPageRoute(builder: (context) => const LoadingScreen());
  /*case articlescreen:
      return MaterialPageRoute(builder: (context) => const ArticleScreen());*/

    default:
      throw ('there is no page');
  }
}



