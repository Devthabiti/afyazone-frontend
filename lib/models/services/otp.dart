import 'dart:async';
import 'dart:convert';

import 'package:afya/client_nav.dart';
import 'package:afya/doctor/doctor_complete_profile.dart';
import 'package:afya/doctor/doctor_nav.dart';
import 'package:afya/models/services/complete_prodile.dart';
import 'package:afya/models/services/utls.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final Map data;
  const OtpPage({super.key, required this.data});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var code = '';
  final formKey = GlobalKey<FormState>();
  bool isVisible = true;

  void _submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      if (code == widget.data['otp']) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Lottie.asset(
                    'assets/load.json',
                    width: 150,
                    height: 150,
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
              );
            });
        postData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'The OTP you entered is incorrect',
                    style: TextStyle(
                        fontFamily: 'Manane',
                        fontSize: 14,
                        color: Color(0xfffe0002), //fe0002,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white,
            elevation: 10,
          ),
        );
      }
    }
  }

// Fetch otp api **************************
  void postData() async {
    var url = Uri.parse('${Api.baseUrl}/login/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "phone": widget.data['phone_number'],
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var iyoo = json.decode(response.body);

      Map<String, dynamic> decodedToken = JwtDecoder.decode(iyoo['token']);
      var userId = decodedToken['user_id'];
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', iyoo['token']);

      var newResponse = await http.post(
        Uri.parse('${Api.baseUrl}/details/'),
        body: json.encode({'id': userId}),
        headers: headers,
      );
      if (newResponse.statusCode == 200) {
        var data = json.decode(newResponse.body);

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
            print('Navigate to complete Doctors page');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => CompleteDoctorProfile()),
                (route) => false);
          }
        }
      } else {
        Navigator.pop(context);
        failMoadal();
      }
    }
  }

  late Timer _timer;
  int _start = 30; // Start time in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Verify Phone Number',
                style: TextStyle(
                    fontFamily: 'Manane',
                    fontSize: 20,
                    color: Color(0xff262626),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Code has been sent to : +${widget.data['phone_number']}',
                style: const TextStyle(
                  fontFamily: 'Manane',
                  color: Color(0xff262626),
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  code = value;
                },
                showCursor: true,
                autofocus: true,
                //errorText: 'Please enter the correct OTP.',
                validator: (value) =>
                    value!.length < 6 ? 'Complete the code' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Didn't get OTP Code ?",
                style: TextStyle(
                    fontFamily: 'Manane',
                    fontSize: 14,
                    color: Color(0xff262626),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _start == 0
                    ? () {
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text(
                  'Resend code',
                  style: TextStyle(
                    fontFamily: 'Manane',
                    fontSize: 14,
                    color: Color(0xfffe0002),
                  ),
                ),
              ),
              Visibility(
                visible: _start != 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    _start.toString(),
                    style: const TextStyle(
                      fontFamily: 'Manane',
                      color: Color(0xff314165),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _submit,
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => CompleteProfile()),
                //     (route) => false);

                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xff0071e7), Color(0xff262626)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp, // This is the default
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          fontFamily: 'Manane',
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
      )),
    );
  }

  failMoadal() {
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Something went Wrong',
                        style: TextStyle(
                          color: Color(0xff262626),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Lottie.asset(
                        'assets/loader.json',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff262626),
                            fontSize: 12,
                          ),
                          "Oops! It looks like Something not correct. \nPlease try again later "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 120,
                            height: 35,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff0071e7),
                                    Color(0xff262626)
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
                              'Close',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
