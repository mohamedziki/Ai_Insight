import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:climate_insight_ai/models/Firestore_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fireStoreServices.dart'; // For persisting fetched IDs

class ArticlesProviderAi extends ChangeNotifier {
  final FirestoreService firestoreService;
  List<Article> _articles = [];
  DocumentSnapshot? _lastDocument;
  Set<String> _fetchedArticleIds = {};  // Using a Set for efficient duplicate checks
  bool _isFetching = false; // Track fetching state
  bool _hasMoreArticles = true; // Flag for end of collection
  Article? _selectedArticle;
  String _keyword = 'Climate Change' ;

  ArticlesProviderAi({required this.firestoreService}) {
  }

  List<Article> get articles => _articles;
  Article? get selectedArticle => _selectedArticle;
  bool get isFetching => _isFetching;
  bool get hasMoreArticles => _hasMoreArticles;
  String get keyword => _keyword;

  void changeKeyword (String categoryName){
   _keyword = categoryName ;
  }

  /* Future<List<Article>> getArticles(String collectionName, int documentLimit) async {
    print('Fetching articles from $collectionName');

    Query query =  FirebaseFirestore.instance
        .collection(collectionName)
        //.where('keyword', isEqualTo: keyword)
        .orderBy('publishedAt', descending: true)
        .limit(documentLimit);


    // If we have a last document, start after it
    if (_lastDocument != null) {
      print('Starting after last document');
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    _lastDocument = querySnapshot.docs.isEmpty ? null : querySnapshot.docs.last;
    print('heere$_lastDocument');

    print('Fetched ${querySnapshot.docs.length} articles');

    return querySnapshot.docs
        .map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }*/

  Stream<List<Article>> getArticlesStream(String collectionName,String keyword) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('keyword',isEqualTo: keyword)
        .orderBy('publishedAt', descending: true)// Ordering based on existing field
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Article.fromJson(doc.data())).toList());

  }

  void updateSelectedArticle(Article article) {
    _selectedArticle = article;
    notifyListeners();
  }

  Future<void> _saveFetchedArticleIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('fetchedArticleIds', _fetchedArticleIds.toList());
  }

  Future<void> _loadFetchedArticleIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList('fetchedArticleIds');
    if (ids != null) {
      _fetchedArticleIds = Set<String>.from(ids);
    }
  }
}