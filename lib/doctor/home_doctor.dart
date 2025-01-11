import 'dart:ui';

import 'package:afya/carsole.dart';
import 'package:afya/doctor/doctor_image.dart';
import 'package:afya/doctor/doctor_story.dart';
import 'package:afya/doctor/profileyadoctor.dart';
import 'package:afya/pages/news.dart';
import 'package:afya/setting/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../doctor/doctor_profile.dart';
import '../home/story.dart';
import '../models/providers/token_provider.dart';
import '../news/news_details.dart';
import 'doctor_news_details.dart';

class HomeDoctor extends StatefulWidget {
  const HomeDoctor({super.key});

  @override
  State<HomeDoctor> createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  @override
  void initState() {
    final data = context.read<ApiCalls>();
    data.fetchDoctor();
    data.fetcharticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var doctor = context.watch<ApiCalls>().allDoctors;
    List doctors = doctor.take(10).toList();
    var articles = context.watch<ApiCalls>().articles;
    List storys =
        articles.where((element) => element['category'] == 'story').toList();
    List story = storys.take(10).toList();
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
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
                          color: Color(0xff314165),
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
                                      builder: (context) => DoctorYaProfile(
                                            doctor: doctors[index],
                                          )));
                            },
                            child: Card(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        'Dr ${doctors[index]['first_name']} ${doctors[index]['last_name']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Manane',
                                            color: const Color(0xff09A599),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        '${doctors[index]['specialize']} - ${doctors[index]['region']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Manane',
                                          color: Color(0xff314165),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 3),
                                            child: Icon(
                                              Icons.star,
                                              size: 20,
                                              color: Color(0xffF6EC72),
                                            ),
                                          ),
                                          Text(
                                            '${average.toStringAsFixed(1)}  | ',
                                            style: TextStyle(
                                              fontFamily: 'Manane',
                                              color: Color(0xff314165),
                                            ),
                                          ),
                                          Text(
                                            '${totalReview} Reviews',
                                            style: TextStyle(
                                              fontFamily: 'Manane',
                                              color: const Color(0xff1684A7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
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
                    'Story Time',
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
                        MaterialPageRoute(builder: (context) => DoctorStory()));
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
                                                      DoctorNewsDetails(
                                                        data: story[index],
                                                      )));
                                        },
                                        child: Container(
                                            width: 100,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: const Color(0xff09A599),
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
          ],
        ),
      ),
    );
  }
}
