import 'dart:convert';
import 'dart:io';

import 'package:afya/client_nav.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/token_provider.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    context.read<ApiCalls>().userID();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    )..addListener(() {
        setState(() {});
      });

    // Optionally loop the animation
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startShake() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  Widget showname() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: username,
            validator: (val) => val!.length < 3
                ? 'Username should be atlest 3 character long'
                : null,
            style: TextStyle(fontSize: 15, color: Color(0xff262626)),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Username",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff262626).withOpacity(0.25),
              ),
            )));
  }

  final items = [
    'Male',
    'Female',
  ];
  String? value;
  //String val = '';
  //drop down menu
  DropdownMenuItem<String> buildMenuItem(String items) =>
      DropdownMenuItem(value: items, child: Text(items));
  Widget showDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: DropdownButtonFormField<String>(
        validator: (val) => val == null ? 'Gender is empty' : null,
        //style: TextStyle(color: Colors.white),
        onChanged: (value) => setState(() {
          this.value = value;
        }),
        items: items.map(buildMenuItem).toList(),
        value: value,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xff262626).withOpacity(0.25),
        ),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xff262626),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 10.0,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          filled: true,
        ),
        // decoration: InputDecoration(
        //   border: OutlineInputBorder(
        //       borderSide: BorderSide(width: 1),
        //       borderRadius: BorderRadius.circular(7.0)),
        //   labelText: 'Relationship to student',
        //   //hintStyle: new TextStyle(color: Colors.white),
        //   // prefixIcon: Icon(Icons.accessibility_new,
        //   //     color: Color.fromARGB(255, 248, 166, 1)),
        // ),
        dropdownColor: Colors.white,
        //iconSize: 0,
        hint: Text(
          'Select Gender',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff262626).withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  // Fetch otp api **************************
  final dio = Dio();
  void postData() async {
    var uid = context.read<ApiCalls>().currentUser;
    // print('hii user $uid');
    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    FormData iyoData;
    if (image == null) {
      iyoData = FormData.fromMap({
        "user_id": int.parse(uid),
        "username": username.text,
        "gender": value,
        "isComplete": true,
      });
    } else {
      iyoData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image!.path,
          //filename: 'name'
        ),
        "user_id": int.parse(uid),
        "username": username.text,
        "gender": value,
        "isComplete": true,
      });
    }

    // PATCH request
    var response = await dio.patch(
      'http://157.230.183.103/update-profile/',
      data: iyoData,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      // print(response.data);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientNav()),
          (route) => false);
    } else {
      Navigator.pop(context);

      failMoadal();
    }
  }

  void _submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
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
    }
  }

  // pick images from gallery and camera
  File? image;
  Future pickImage(
    ImageSource source,
  ) async {
    try {
      final img = await ImagePicker().pickImage(source: source);

      final tempimg = File(img!.path);
      setState(() {
        image = tempimg;
      });
    } catch (e) {
      print(e);
    }
  }

  myDialogy() {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              backgroundColor: Color(0xffF6F6F6),
              // title:
              //     Text('Choose photo from'),
              content: Container(
                //color: Colors.amber,
                height: 150,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                          // textAlign: TextAlign.start,
                          'Choose photo ',
                          style: TextStyle(
                              color: Color(0xff314165),
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                            child: Card(
                              color: Color(0xff1684A7),
                              child: Column(
                                children: const [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: Color(0xffF6F6F6),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Gallery',
                                        style: TextStyle(
                                          color: Color(0xffF6F6F6),
                                          fontFamily: 'Manane',
                                          fontSize: 12,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                            child: Card(
                              color: Color(0xff1684A7),
                              child: Column(
                                children: const [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Color(0xffF6F6F6),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Camera',
                                        style: TextStyle(
                                          color: Color(0xffF6F6F6),
                                          fontFamily: 'Manane',
                                          fontSize: 12,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // actions: [
              //   ElevatedButton(
              //       onPressed: () {
              //         pickImage(
              //             ImageSource
              //                 .gallery,
              //             myState);
              //         Navigator.pop(
              //             context);
              //       },
              //       child:
              //           Text('ok'))
              // ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        elevation: 1,
        title: const Text(
          'Complete Profile',
          style: TextStyle(
            color: Color(0xff262626),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              GestureDetector(
                  onTap: _startShake,
                  child: Transform.translate(
                      offset: Offset(_animation.value, 0),
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.all(25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          // color: Color(0xff09A599).withOpacity(0.25)
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff1684A7).withOpacity(0.65),
                              Color(0xff0071e7).withOpacity(0.65)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp, // This is the default
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'almost there please complete profile',
                              style: TextStyle(
                                  fontFamily: 'Manane',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('to enjoy the app',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    color: Color(0xffF6F6F6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ))),
              SizedBox(
                height: 20,
              ),

              image == null
                  ? GestureDetector(
                      onTap: () {
                        myDialogy();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.25),
                        radius: 80,
                        child: Stack(
                          //alignment: Alignment.bottomLeft,
                          children: [
                            Positioned(
                              bottom: -25,
                              right: 20,
                              child: Lottie.asset('assets/user.json',
                                  height: 220, width: 120
                                  //fit: BoxFit.cover
                                  ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Color(0xff0071e7),
                                child: FaIcon(
                                  FontAwesomeIcons.pencil,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        myDialogy();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: ClipOval(
                          child: Stack(
                            //alignment: Alignment.bottomLeft,
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Image.file(
                                  image!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 15,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Color(0xff1684A7),
                                  child: FaIcon(
                                    FontAwesomeIcons.pencil,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),

              SizedBox(
                height: 20,
              ),
              // Divider(
              //     //height: 20,
              //     ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   child: Text(
              //     'USERNAME',
              //     style: TextStyle(
              //       fontFamily: 'Manane',
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              showname(),
              showDropdown(),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _submit,
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => ClientNav()),
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
                  child: Center(
                    child: Text(
                      'Complete Now',
                      style: TextStyle(
                          fontFamily: 'Manane',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
                          "Oops! It looks like Something not correct. \nor username is already used"),
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
