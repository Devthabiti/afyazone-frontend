import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:afya/carsole.dart';
import 'package:afya/doctor/doctor_image.dart';
import 'package:afya/home/food.dart';
import 'package:afya/home/magonjwa.dart';
import 'package:afya/home/story.dart';
import 'package:afya/pages/news.dart';
import 'package:afya/setting/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../doctor/doctor_profile.dart';
import '../models/providers/token_provider.dart';
import '../news/news_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> welcomeMessages = [
    "Afya yako ni utajiri wako 💎",
    "Kula vyakula vyenye virutubisho 🥗",
    "Kunywa maji mengi kila siku 💧",
    "Pumzika vya kutosha kwa afya bora 😴",
    "Kuwa na furaha, afya yako inategemea hilo 😃",
    "Epuka msongo wa mawazo 🧘‍♂️",
    "Penda mwili wako, utajali afya yako ❤️",
    "Tumia matunda na mboga kwa wingi 🍎",
    "Afya bora huanzia na akili yenye utulivu 🧠",
    "Tabasamu ni tiba ya moyo 😊",
    "Hakikisha unapata usingizi wa kutosha 🌙",
    "Punguza sukari kwa afya bora 🚫🍬",
    "Epuka vyakula vya mafuta mengi 🍟",
    "Zoezi ni dawa ya mwili 🏃‍♀️",
    "Afya njema huleta maisha marefu 🌿",
    "Tumia muda na wapendwa wako, ni tiba ya moyo 👨‍👩‍👧‍👦",
    "Chagua afya leo kwa maisha bora kesho ⏳",
    "Epuka uvutaji wa sigara kwa mapafu safi 🚭",
    "Hakikisha unakula kiamsha kinywa kila siku 🍞",
    "Tembea angalau dakika 30 kila siku 🚶‍♂️",
    "Cheka mara nyingi, ni tiba asilia 😂",
    "Kuwa na ratiba nzuri ya kula ⏰🍽️",
    "Afya njema huleta nguvu ya kufanya kazi 💪",
    "Epuka kunywa pombe kupita kiasi 🚫🍷",
    "Usafi wa mwili huimarisha kinga yako 🛁",
    "Fanya uchunguzi wa afya mara kwa mara 🏥",
    "Afya njema huanza na maamuzi mazuri ✅",
  ];

  String currentMessage = "Afya ni mtaji 💪";
  Timer? _timer;
  double rate = 1.0;

  @override
  void initState() {
    final data = context.read<ApiCalls>();
    data.fetchUserDetails();
    data.fetchDoctor();
    data.fetcharticles();
    data.fetchads();

    _startTimer();

    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  // Function to start the timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        // Update the current message with a random one from the list
        currentMessage =
            welcomeMessages[Random().nextInt(welcomeMessages.length)];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ApiCalls>().clientData;
    var doctor = context.watch<ApiCalls>().allDoctors;
    List doctors = doctor.take(5).toList();
    var articles = context.watch<ApiCalls>().articles;
    //list all caterogies
    List magonjwas =
        articles.where((element) => element['label'] == 'magonjwa').toList();

    List magonjwa = magonjwas.take(10).toList();
    List storys =
        articles.where((element) => element['category'] == 'story').toList();
    List story = storys.take(10).toList();
    List foods =
        articles.where((element) => element['label'] == 'chakula').toList();
    List food = foods.take(10).toList();
    List hot = articles.take(10).toList();
    hot.sort((a, b) => b['views'].compareTo(a['views']));
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFFFFFF),
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    'Habari ${data['username']} 👋',
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  currentMessage,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff262626),
                    fontSize: 10,
                  ),
                ),
                // Text(
                //   '${data['username']} 👋',
                //   style: TextStyle(
                //       fontFamily: 'Manane',
                //       color: const Color(0xff1684A7),
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                // )
              ],
            ),
            data['image'] == null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xffF6EC72),
                          backgroundImage: data['gender'] == "Male"
                              ? AssetImage('assets/man.png')
                              : AssetImage('assets/woman.png')),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: CachedNetworkImage(
                        imageUrl: 'http://157.230.183.103${data['image']}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 25,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xffF6EC72),
                            backgroundImage: data['gender'] == "Male"
                                ? AssetImage('assets/man.png')
                                : AssetImage('assets/woman.png')),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: ListView(
        children: [
          Divider(),
          CarsolePge(),
          const SizedBox(
            height: 10,
          ),
          doctors.isEmpty
              ? Container()
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Top Doctors',
                    style: TextStyle(
                        fontFamily: 'Manane',
                        fontSize: 16,
                        color: Color(0xff262626),
                        fontWeight: FontWeight.bold),
                  ),
                ),
          doctors.isEmpty
              ? Container()
              : ListView.builder(
                  itemCount: doctors.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    double totalRating = 0.0;
                    double average = 0.0;
                    var totalReview = 0;
                    if (doctors[index]['review'].isNotEmpty) {
                      List review = doctors[index]['review'];

                      for (var data in review) {
                        totalRating += data['rating'];
                      }
                      totalReview = review.length;
                      average = totalRating / totalReview;
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DoctorProfile(
                                          doctor: doctors[index],
                                        )));
                          },
                          child: Card(
                              color: Color(0xffFFFFFF),
                              elevation: 0,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageViewPage(
                                                  name:
                                                      'Dr ${doctors[index]['first_name']} ${doctors[index]['last_name']}',
                                                  imageUrl:
                                                      'http://157.230.183.103${doctors[index]['image']}')));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'http://157.230.183.103${doctors[index]['image']}',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        margin: EdgeInsets.all(15),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover)),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/logo.jpg'))),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          'Dr ${doctors[index]['first_name']} ${doctors[index]['last_name']}'
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'Manane',
                                              color: const Color(0xff262626),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RatingBar.builder(
                                              initialRating: 3,
                                              direction: Axis.horizontal,
                                              // allowHalfRating: true,
                                              itemCount: 4,
                                              itemSize: 15,
                                              ignoreGestures: true,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.diamond,
                                                color: const Color(0xfffe0002),
                                              ),
                                              onRatingUpdate: (rating) {
                                                rate = rating;
                                                // print(rate);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, bottom: 3),
                                            child: Text(
                                              '( MD )',
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                fontSize: 12,
                                                color: const Color(0xff262626),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          '${doctors[index]['specialize']} - ${doctors[index]['region']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Manane',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            color: Color(0xff262626),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          'TZS ${doctors[index]['price']}/= Per Person',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Manane',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            color: Color(0xff262626),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 5),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 3),
                                              child: Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Color(0xff0071e7),
                                              ),
                                            ),
                                            Text(
                                              '${average.toStringAsFixed(1)}  | ',
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                color: Color(0xff262626),
                                              ),
                                            ),
                                            Text(
                                              '${totalReview} Reviews',
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                color: Color(0xff0071e7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Text(
                  'Popular',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 16,
                      color: Color(0xff262626),
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewsPage()));
                },
                child: const Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 20),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff262626),
                    ),
                  ),
                ),
              ),
            ],
          ),
          hot.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/loader.json',
                    width: 100,
                    height: 100,
                  ),
                )
              : SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: hot.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(15),
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color(0xff0071e7),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                              imageUrl: '${hot[index]['image']}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          topRight: Radius.circular(7)),
                                    ),
                                    height: 170,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            left: 20,
                                            top: 10,
                                            height: 30,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors
                                                      .white, //Color(0xff0071e7).withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Color(0xff0071e7),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Text(
                                                      "${NumberFormat.compact().format(hot[index]['views'])} Views",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff262626),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            )),
                                        Positioned(
                                            right: 10,
                                            top: 10,
                                            height: 30,
                                            child: Container(
                                                child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xfffe0002),
                                              child: Icon(
                                                Icons.local_fire_department,
                                                size: 22,
                                                color: Colors.white,
                                              ),
                                            ))),
                                      ],
                                    ),
                                  )),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              //overflow: TextOverflow.ellipsis,

                              hot[index]['title'].toUpperCase(),
                              textAlign: TextAlign.center,

                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  )),

          // ************ HOT ARTICLES *************
          SizedBox(
            height: 20,
            // child: Text('data'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Hot Articles 🔥',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 16,
                      color: Color(0xff314165),
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewsPage()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff314165),
                    ),
                  ),
                ),
              ),
            ],
          ),
          hot.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/loader.json',
                    width: 100,
                    height: 100,
                  ),
                )
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                      childAspectRatio: 0.8),
                  padding: EdgeInsets.all(8.0),
                  itemCount: hot.length, // Number of items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final data = context.read<ApiCalls>();
                        data.fetchview(hot[index]['id'].toString());
                        data.fetcharticles();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      data: hot[index],
                                    )));
                      },
                      child: CachedNetworkImage(
                        imageUrl: '${hot[index]['image']}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 80,
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.2), // Shadow color with opacity
                                        spreadRadius:
                                            4.0, // Spread radius of the shadow
                                        blurRadius:
                                            10.0, // Blur radius of the shadow
                                        offset: Offset(0,
                                            -5), // Offset of the shadow (x, y)
                                      ),
                                    ],
                                    color: Color(0xff314165).withOpacity(0.6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      hot[index]['title'].toUpperCase(),
                                      textAlign: TextAlign.center,
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/logo.jpg'))),
                        ),
                      ),
                    );
                  }),

          // ************ KUUZA BIDHAAAAAA *************
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Our Pharmacy (Nunua Dawa)',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 16,
                      color: Color(0xff314165),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 25,
                    color: Color(0xff314165),
                  )),
            ],
          ),
          Container(
            height: 160,
            //width: double.infinity,
            //color: Colors.amber,
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5),
                    //padding: EdgeInsets.all(10),
                    //height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                            image: AssetImage('assets/da3.jpg'),
                            fit: BoxFit.cover)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 25),
                          child: Text(
                            'Comming Soon',
                            style: TextStyle(
                                fontFamily: 'Manane',
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 15.0,
                ),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    //padding: EdgeInsets.all(10),
                    //height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                            image: AssetImage('assets/da1.jpg'),
                            fit: BoxFit.cover)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 25),
                          child: Text('Comming Soon',
                              style: TextStyle(
                                  fontFamily: 'Manane',
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 15.0,
                ),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    //padding: EdgeInsets.all(10),
                    //height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                            image: AssetImage('assets/da2.jpg'),
                            fit: BoxFit.cover)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 25),
                          child: Text('Coming soon',
                              style: TextStyle(
                                  fontFamily: 'Manane',
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 15.0,
                ),
              ],
            ),
          ),
          // ************ MAJONGWA *************
          SizedBox(
            height: 20,
            // child: Text('data'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Disease (Majongwa)',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 16,
                      color: Color(0xff314165),
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Magonjwa()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff314165),
                    ),
                  ),
                ),
              ),
            ],
          ),
          magonjwa.isEmpty
              ? Center(
                  child: Lottie.asset(
                  'assets/loader.json',
                  width: 100,
                  height: 100,
                ))
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                      childAspectRatio: 0.8),
                  padding: EdgeInsets.all(8.0),
                  itemCount: magonjwa.length, // Number of items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final data = context.read<ApiCalls>();
                        data.fetchview(magonjwa[index]['id'].toString());
                        data.fetcharticles();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      data: magonjwa[index],
                                    )));
                      },
                      child: CachedNetworkImage(
                        imageUrl: '${magonjwa[index]['image']}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 80,
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.2), // Shadow color with opacity
                                        spreadRadius:
                                            4.0, // Spread radius of the shadow
                                        blurRadius:
                                            10.0, // Blur radius of the shadow
                                        offset: Offset(0,
                                            -5), // Offset of the shadow (x, y)
                                      ),
                                    ],
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  child: Center(
                                    child: Text(
                                      magonjwa[index]['title'].toUpperCase(),
                                      textAlign: TextAlign.center,
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          // color: Colors.white,
                                          color: Color(0xff314165),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/logo.jpg'))),
                        ),
                      ),
                    );
                  }),
          // ************ Story time *************
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Love & Sex',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 16,
                      color: Color(0xff314165),
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Story()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff314165),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: story.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                      imageUrl: '${story[index]['image']}',
                      imageBuilder: (context, imageProvider) => Container(
                          width: 280,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, left: 15),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  story[index]['title'].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, right: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        final data = context.read<ApiCalls>();
                                        data.fetchview(
                                            story[index]['id'].toString());
                                        data.fetcharticles();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetails(
                                                      data: story[index],
                                                    )));
                                      },
                                      child: Container(
                                          width: 100,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Color(0xff1684A7),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                              child: Text(
                                            'Read now',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )));
                },
              )

              //  ListView(
              //   // physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   scrollDirection: Axis.horizontal,
              //   children: [
              //     SizedBox(
              //       width: 15.0,
              //     ),

              //     SizedBox(
              //       width: 15.0,
              //     ),
              //   ],
              // ),
              ),
          // ************ MATUNDA NA CHAKULA *************
          SizedBox(
            height: 20,
            // child: Text('data'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Food & Fruits',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 16,
                      color: Color(0xff314165),
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Food()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff314165),
                    ),
                  ),
                ),
              ),
            ],
          ),
          food.isEmpty
              ? Center(
                  child: Lottie.asset(
                  'assets/loader.json',
                  width: 100,
                  height: 100,
                ))
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                      childAspectRatio: 0.8),
                  padding: EdgeInsets.all(8.0),
                  itemCount: food.length, // Number of items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final data = context.read<ApiCalls>();
                        data.fetchview(food[index]['id'].toString());
                        data.fetcharticles();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      data: food[index],
                                    )));
                      },
                      child: CachedNetworkImage(
                        imageUrl: '${food[index]['image']}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 80,
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.2), // Shadow color with opacity
                                        spreadRadius:
                                            4.0, // Spread radius of the shadow
                                        blurRadius:
                                            10.0, // Blur radius of the shadow
                                        offset: Offset(0,
                                            -5), // Offset of the shadow (x, y)
                                      ),
                                    ],
                                    color: Color(0xff314165).withOpacity(0.6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      food[index]['title'].toUpperCase(),
                                      textAlign: TextAlign.center,
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/logo.jpg'))),
                        ),
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
