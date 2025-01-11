import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'client_nav.dart';
import 'doctor/doctor_complete_profile.dart';
import 'doctor/doctor_nav.dart';
import 'models/services/complete_prodile.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // Fetch otp api **************************
  void postData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    var userId = decodedToken['user_id'];
    var url = Uri.parse('http://157.230.183.103/details/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {'id': userId};

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['role'] == "Client") {
        if (data['completed'] == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ClientNav()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => CompleteProfile()),
              (route) => false);
        }
      } else {
        if (data['completed'] == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DoctorNav()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => CompleteDoctorProfile()),
              (route) => false);
        }
      }
    }
  }

  @override
  void initState() {
    postData();
    _startTimer();
    super.initState();
  }

  //show scafford messanger
  Timer? _timer;
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 8), (Timer timer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Check your internet connections',
                    style: TextStyle(
                        fontFamily: 'Manane',
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Lottie.asset(
                  'assets/load.json',
                  width: 90,
                  height: 90,
                ),
              ],
            ),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: const Color(
              0xff1684A7), // Duration for which the SnackBar will be visible
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: Text('no internet connections'),

    //     ///this is very strong page
    //     ///the internt should be avalible beacause
    //     ///we check if user is complete profile or not
    //     ///i should user shimmer effect to make page more good
    //   ),
    // );
    return Scaffold(
      //appBar: AppBar(),
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
    );
  }
}
