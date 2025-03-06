import 'dart:convert';

import 'package:afya/models/services/otp.dart';
import 'package:afya/terms.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../client_nav.dart';
import '../../doctor/doctor_complete_profile.dart';
import '../../doctor/doctor_nav.dart';
import 'complete_prodile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phone = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Widget showphone() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: phone,
            //autofocus: true,
            validator: (val) =>
                val!.length < 9 ? 'Complete Phone Number' : null,
            style: TextStyle(fontSize: 15, color: Color(0xff262626)),
            keyboardType: TextInputType.phone,
            maxLength: 9,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Phone Number",
              // prefix: Text('255 : '),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  '+255 : ',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff092058).withOpacity(0.25),
                      fontWeight: FontWeight.bold),
                ),
              ),
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

// Fetch otp api **************************
  void postData() async {
    var url = Uri.parse('http://157.230.183.103/send-otp/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "phone": "255${phone.text}",
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
      // getData(iyoo['data']['token'], iyoo['refresh_token']);
      print(iyoo);

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpPage(
                    data: iyoo,
                  )));
    } else {
      Navigator.pop(context);
      failMoadal();
    }
  }

// Login bypass otp **************************
  void postLogin() async {
    var url = Uri.parse('http://157.230.183.103/login/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "phone": "255${phone.text}",
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
        Uri.parse('http://157.230.183.103/details/'),
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

  void _submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Center(
      //           child: Lottie.asset(
      //             'assets/load.json',
      //             width: 150,
      //             height: 150,
      //           ),
      //         ),
      //         elevation: 0,
      //         backgroundColor: Colors.transparent,
      //         // shape: RoundedRectangleBorder(
      //         //     borderRadius: BorderRadius.circular(20)),
      //       );
      //     });
      // if (phone.text == '659242027') {
      //   postLogin();
      // } else {
      //   postData();
      // }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpPage(
                    data: {},
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                flex: 9,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Color(0xff0071e7),
                                backgroundImage:
                                    AssetImage('assets/afyazonel.png'),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 10),
                            //   child: Text(
                            //     'Afya zone',
                            //     style: TextStyle(
                            //         fontFamily: 'Manane',
                            //         fontSize: 25,
                            //         color: Color(0xff0071e7),
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Text(
                          'Hi! welcome to AfyaZone',
                          style: TextStyle(
                              fontFamily: 'Manane',
                              fontSize: 20,
                              color: Color(0xff262626),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Get started by providing your phone number.',
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff262626),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        showphone(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _submit,
                              child: Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                                ),
                                child: const Center(
                                  child: Text(
                                    'Continue',
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              'By continuing, you agree to our',
                              style: TextStyle(
                                fontFamily: 'Manane',
                                color: Color(0xff262626),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TermsPage()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    fontSize: 14,
                                    color: Color(0xfffe0002),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        )),
      ),
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Something went Wrong',
                        style: TextStyle(
                          color: Color(0xff314165),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff314165),
                            fontSize: 12,
                          ),
                          "Oops! It seems like the phone number is not correct. or Something not correct"),
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
                            child: const Center(
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
