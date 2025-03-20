import 'package:afya/models/services/service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCalls extends ChangeNotifier {
  String currentUser = '';

  userID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    final id = decodedToken['user_id'].toString();

    currentUser = id;
    notifyListeners();
  }

  //Provider ya kufetch client Details
  var clientData = {};
  fetchUserDetails() async {
    clientData = await fetchClientDetails();

    notifyListeners();
  }

  //Provider ya kufetch list of doctors
  var allDoctors = [];
  fetchDoctor() async {
    allDoctors = await fetchDoctors();

    notifyListeners();
  }

  //Provider ya kufetch my inbox message
  var myInbox = [];
  fetchInbox() async {
    myInbox = await fetchInboxes();

    notifyListeners();
  }

  //Provider ya kufetch 1 vs 1 chat message
  var mesage = [];
  fetchchat(sender, receiver) async {
    mesage = await getChats(sender, receiver);

    notifyListeners();
  }

  //Provider ya kufetch stories and articles
  var articles = [];
  fetcharticles() async {
    articles = await getnews();

    notifyListeners();
  }

//Provider ya kufetch to 10 Articles with views
  var mostviews = [];
  fetchMostViews() async {
    mostviews = await getmostviews();

    notifyListeners();
  }

//Provider ya kufetch to most like Articles with random concept
  var randomly = [];
  fetchRandom() async {
    randomly = await getrandom();

    notifyListeners();
  }

  //Provider ya kufetch to most like Articles
  var mostliked = [];
  fetchMostLiked() async {
    mostliked = await getmostliked();

    notifyListeners();
  }

  //Provider ya kufetch hot Articles
  var hotarticle = [];
  fetchHotArticles() async {
    hotarticle = await gethotarticle();

    notifyListeners();
  }

  //Provider ya kufetch ads
  var matangazo = [];
  fetchads() async {
    matangazo = await getads();

    notifyListeners();
  }

  //Provider ya kufetch phamacy images
  var phamacy = [];
  fetchPhamacy() async {
    phamacy = await getphamacy();

    notifyListeners();
  }

  //Provider ya kufetch stories and articles
  var transactions = [];
  fetchtransaction() async {
    transactions = await gettransaction();

    notifyListeners();
  }

  //Provider ya kuupdate number of views

  fetchview(postId) async {
    await fetchvievs(postId);

    notifyListeners();
  }
}
