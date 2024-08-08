import 'package:carousel_slider/carousel_slider.dart';
import 'package:climate_insight_ai/pages/article_screen.dart';
import 'package:climate_insight_ai/models/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'home_screen.dart';
import '../models/Firestore_Model.dart';

class BreakingNews extends StatefulWidget {
  @override
  State<BreakingNews> createState() => _BreakingNewsState();
}

class _BreakingNewsState extends State<BreakingNews> {
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final articlesProvider =
        Provider.of<ArticlesProviderAi>(context, listen: false);
    return StreamBuilder<List<Article>>(
      stream: articlesProvider.getArticlesStream(
          'Us_Climate_Change', articlesProvider.keyword),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingList();
        } else if (snapshot.hasError) {
          return _buildErrorText(snapshot.error.toString());
        } else if (snapshot.hasData) {
          final articles = snapshot.data!;
          if (articles.isNotEmpty && articlesProvider.selectedArticle == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              articlesProvider.updateSelectedArticle(articles[0]);
            });
          }
          return _buildArticleList(context, articles);
        } else {
          return _buildErrorText('Unknown error');
        }
      },
    );
  }

  Widget _buildErrorText(String error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildArticleList(BuildContext context, List<Article> articles) {
    return CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: articles.length,
        itemBuilder: (context, index, realIndex) {
          if (articles.isEmpty) {
            return _buildLoadingList();
          } else {
            Article article = articles[index];
            return GestureDetector(
              onTap: () => (),
              child: _buildArticleItem(context, article),
            );
          }
        },
        options: CarouselOptions(
          onPageChanged: (index, reason) {
            Provider.of<ArticlesProviderAi>(context, listen: false)
                .updateSelectedArticle(articles[index]);
          },
          pauseAutoPlayInFiniteScroll: false,
          height: 340,
          enlargeCenterPage: false,
          viewportFraction: 0.85,
          enableInfiniteScroll: true,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget _buildArticleItem(BuildContext context, Article article) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleScreen(article: article),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: HottestNews(
            mostAffectedCountry: article.mostAffectedCountry!,
            urgency: article.urgency!,
            responsibility: article.responsibility!,
            region: article.mostAffectedCountry!,
            impact: article.impact!,
            degreeOfImpact: article.degreeOfImpact!,
            image: article.image!,
            title: article.title!,
            hoursAgo: '${article.publishedAt!.minute} minutes ago',
            source: article.source!['name'],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return CarouselSlider.builder(
      itemCount: 2,
      itemBuilder: (context, index, realIndex) => Padding(
        padding: const EdgeInsets.all(10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            width: 330,
            height: 370,
          ),
        ),
      ),
      options: CarouselOptions(
        pauseAutoPlayInFiniteScroll: true,
        height: 370,
        enlargeCenterPage: false,
        viewportFraction: 0.85,
        enableInfiniteScroll: true,
        autoPlay: false,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
