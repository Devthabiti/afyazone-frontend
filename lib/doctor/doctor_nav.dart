import 'dart:async';
import 'dart:convert';

import 'package:afya/doctor/doctor_chat.dart';
import 'package:afya/doctor/doctor_news.dart';
import 'package:afya/doctor/home_doctor.dart';
import 'package:afya/pages/chat.dart';
import 'package:afya/pages/doctors.dart';
import 'package:afya/pages/home.dart';
import 'package:afya/pages/news.dart';
import 'package:afya/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';
import 'doctor_setting.dart';

class DoctorNav extends StatefulWidget {
  const DoctorNav({Key? key}) : super(key: key);

  @override
  State<DoctorNav> createState() => _DoctorNavState();
}

class _DoctorNavState extends State<DoctorNav> {
  late PageController pageController;
  int pageIndex = 0;

  //nafikiri hapa ndo ntacall api zote before sijaingia ndani
  // na api niziweke kwenye context yaan providers
  @override
  void initState() {
    final data = context.read<ApiCalls>();
    // data.fetchUserDetails();

    data.fetchDoctor();
    data.fetchInbox();
    data.fetcharticles();
    data.fetchtransaction();
    data.fetchads();
    context.read<ApiCalls>().userID();
    pageController = PageController();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

//Update Doctor Status
// Fetch otp api **************************
  void postData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    final uid = decodedToken['user_id'].toString();
    print('my UID is $uid');
    var url = Uri.parse('${Api.baseUrl}update_doctor_status/');
    // print('my UID is $uid');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {"user_id": uid, 'is_online': true};

    // POST request
    await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );
  }

  // Function to start the timer
  Timer? _timer;
  void _startTimer() {
    postData();
    _timer = Timer.periodic(Duration(minutes: 4), (timer) {
      setState(() {
        postData();
      });
    });
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ApiCalls>().allDoctors;
    // print('******** SEND DOCTOR STATUS *********');

    return data.isEmpty //apa ntaweka & condition kufetch data zote
        ? Scaffold(
            body: SafeArea(
              child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: 6,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ListTile(
                            leading: Container(
                              width: 70.0,
                              height: 56.0,
                              color: Colors.white,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 250.0,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 200.0,
                                  height: 15.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            subtitle: Container(
                              width: 170.0,
                              height: 86.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )
        : Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                HomeDoctor(),
                NewsDoctor(),
                ChatDoctor(),
                DoctorSetting()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: pageIndex,
                onTap: onTap,
                fixedColor: const Color(0xffF6EC72),
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: const Color(0xffF6F6F6),
                backgroundColor: const Color(0xff09A599),
                elevation: 10,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        Iconsax.home1,
                      ),
                      icon: Icon(
                        Iconsax.home,
                      )),
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        FontAwesomeIcons.fireFlameCurved,
                        size: 22,
                      ),
                      icon: Icon(
                        FontAwesomeIcons.fire,
                        size: 22,
                      )),
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        Iconsax.message1,
                      ),
                      icon: Icon(
                        Iconsax.message_favorite,
                      )),
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        Iconsax.setting1,
                      ),
                      icon: Icon(
                        Iconsax.setting,
                        // size: 20,
                      )),
                ]),
          );
  }
}
