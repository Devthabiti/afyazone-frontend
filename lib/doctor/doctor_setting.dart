import 'package:afya/doctor/doctor_edit_proflie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

import '../models/providers/token_provider.dart';
import '../models/services/login.dart';
import '../onboarding.dart';
import '../terms.dart';

class DoctorSetting extends StatefulWidget {
  const DoctorSetting({super.key});

  @override
  State<DoctorSetting> createState() => _DoctorSettingState();
}

class _DoctorSettingState extends State<DoctorSetting> {
  @override
  Widget build(BuildContext context) {
    var miamala = context.watch<ApiCalls>().transactions;
    var uid = context.watch<ApiCalls>().currentUser;

    List trans = miamala
        .where((element) =>
            element['doctor'] == int.parse(uid) && element['status'] == 'Not')
        .toList();
    print(trans);
    int totalAmount =
        trans.fold(0, (sum, item) => sum + (int.parse(item['amount'])));

    print('Total amount: $totalAmount');
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: const Color(0xff09A599),
          toolbarHeight: 100,
          title: Text(
            'Setting',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true),
      body: Container(
          color: Colors.grey.withOpacity(0.1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xff09A599).withOpacity(0.25)
                        // image: DecorationImage(
                        //     image: AssetImage('assets/da3.jpg'),
                        //     fit: BoxFit.cover)
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 25),
                          child: Text(
                            'Current Balance',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 25),
                              child: Text(
                                '$totalAmount TZS',
                                style: TextStyle(
                                    color: const Color(0xff314165),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                String number = '+255777048047';
                                final url = 'https://wa.me/$number';
                                launchUrl(Uri.parse(url));
                              },
                              child: Container(
                                  width: 100,
                                  margin:
                                      const EdgeInsets.only(top: 20, left: 25),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1684A7),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                    'Withdraw',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ))),
                            ),
                          ],
                        ),
                      ],
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDoctorProfile()));
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Profile Settings',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 20),
                          child: Text(
                            'Manage details of your Afyazone Account',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xff314165),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Platform.isAndroid
                        ? Share.share(
                            'check out our Application from Google Play Store https://play.google.com/store/apps/details?id=com.david.zone')
                        : Share.share(
                            'check out our Application from App Store https://apps.apple.com/us/app/tiktok/id835599320');
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Share App',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 20),
                          child: Text(
                            'You can share the app to your friends and family.',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TermsPage()));
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 20),
                          child: Text(
                            'Read our support privacy policy carefully and contact our support team',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TermsPage()));
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Terms & Condition',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 20),
                          child: Text(
                            'Read our terms and conditions carefully before using our app.',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    deleteMoadal();
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 20),
                          child: Text(
                            'You can request to delete your accoount',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs
                        .remove('token')
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false));
                    ;
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 20),
                          child: Text(
                            'Sign out of the application',
                            style: TextStyle(
                              color: const Color(0xff314165),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  deleteMoadal() {
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: ((context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        'Delete Your Account',
                        style: TextStyle(
                          color: Color(0xff314165),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 1),
                    //   child: Lottie.asset(
                    //     'assets/loader.json',
                    //     width: 100,
                    //     height: 100,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff314165),
                            fontSize: 12,
                          ),
                          "Are you sure you want to delete your account?"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 80,
                                height: 35,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xff314165),
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs
                                  .remove('token')
                                  .then((value) => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false));
                            },
                            child: Container(
                                width: 80,
                                height: 35,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff1684A7),
                                        Color(0xff09A599)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [0.0, 1.0],
                                      tileMode:
                                          TileMode.clamp, // This is the default
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
