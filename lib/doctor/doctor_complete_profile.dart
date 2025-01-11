import 'dart:io';

import 'package:afya/doctor/doctor_nav.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/providers/token_provider.dart';

class CompleteDoctorProfile extends StatefulWidget {
  const CompleteDoctorProfile({super.key});

  @override
  State<CompleteDoctorProfile> createState() => _CompleteDoctorProfileState();
}

class _CompleteDoctorProfileState extends State<CompleteDoctorProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController hospital = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController region = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController specialize = TextEditingController();
  TextEditingController exiperience = TextEditingController();
  TextEditingController bio = TextEditingController();

  Widget showfname() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: fname,
            validator: (val) => val!.length < 3
                ? 'First name should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
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
              hintText: "First Name",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showlname() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: lname,
            validator: (val) => val!.length < 3
                ? 'Last name should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
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
              hintText: "Last Name",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showregion() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: region,
            validator: (val) => val!.length < 3
                ? 'Region should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
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
              hintText: "Region",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showdistr() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: district,
            validator: (val) => val!.length < 3
                ? 'District should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
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
              hintText: "District",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showhosp() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: hospital,
            validator: (val) => val!.length < 3
                ? 'Hospital should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
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
              hintText: "Hospital",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showspec() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: specialize,
            validator: (val) => val!.length < 3
                ? 'Specialization should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
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
              hintText: "Specialize on",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showexp() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: exiperience,
            validator: (val) => val!.isEmpty
                ? 'Exiperience should be atlest 3 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Exiperience",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  Widget showbio() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: bio,
            validator: (val) => val!.length < 50
                ? 'Bio should be atlest 50 character long'
                : null,
            style: TextStyle(
              fontSize: 15,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Bio",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xff092058).withOpacity(0.25),
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
          color: Color(0xff092058).withOpacity(0.25),
        ),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xff092058),
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
            color: Color(0xff092058).withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  final startItems = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  String? valuestart;
  //String val = '';
  //drop down menu
  DropdownMenuItem<String> buildMenuItemstart(String items) =>
      DropdownMenuItem(value: items, child: Text(items));
  Widget showstart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: DropdownButtonFormField<String>(
        validator: (val) => val == null ? 'Select Starting Date' : null,
        //style: TextStyle(color: Colors.white),
        onChanged: (value) => setState(() {
          valuestart = value;
        }),
        items: startItems.map(buildMenuItemstart).toList(),
        value: valuestart,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xff092058).withOpacity(0.25),
        ),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xff092058),
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
          'Start Date',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff092058).withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  final startEnd = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  String? valueend;
  //String val = '';
  //drop down menu
  DropdownMenuItem<String> buildMenuItemend(String items) =>
      DropdownMenuItem(value: items, child: Text(items));
  Widget showend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: DropdownButtonFormField<String>(
        validator: (val) => val == null ? 'Select Ending Date' : null,
        //style: TextStyle(color: Colors.white),
        onChanged: (value) => setState(() {
          valueend = value;
        }),
        items: startEnd.map(buildMenuItem).toList(),
        value: valueend,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xff092058).withOpacity(0.25),
        ),
        style: TextStyle(
          fontSize: 15,
          color: Color(0xff092058),
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
          'End Date',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff092058).withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    context.read<ApiCalls>().userID();
    super.initState();
  }

  // Fetch otp api **************************
  final dio = Dio();
  void postData() async {
    var uid = context.read<ApiCalls>().currentUser;
    print('hii user $uid');
    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    FormData iyoData;

    iyoData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image!.path,
        //filename: 'name'
      ),
      "user_id": int.parse(uid),
      "first_name": fname.text,
      "last_name": lname.text,
      "region": region.text,
      "district": district.text,
      "hospital": hospital.text,
      "specialize": specialize.text,
      "experience": exiperience.text,
      "bio": bio.text,
      "start_day": valuestart,
      "end_day": valueend,
      "gender": value,
      "isComplete": true,
    });

    // PATCH request
    var response = await dio.patch(
      'http://157.230.183.103/update-doctor-profile/',
      data: iyoData,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      print(response.data);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DoctorNav()),
          (route) => false);
    } else {
      Navigator.pop(context);

      failMoadal();
      print('Request failed with status: ${response.statusCode}');
      print(response.data);
    }
  }

  void _submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      if (image != null) {
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
          const SnackBar(
            content: Center(
              child: Text('No Image selected'),
            ),
            duration: Duration(seconds: 4),
            //padding: EdgeInsets.all(15),
            backgroundColor: Color(
                0xff1684A7), // Duration for which the SnackBar will be visible
          ),
        );
      }
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
                              color: const Color(0xff09A599),
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
                              color: const Color(0xff09A599),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Complete Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),

                image == null
                    ? Center(
                        child: GestureDetector(
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
                                      backgroundColor: Color(0xff1684A7),
                                      child: FaIcon(
                                        FontAwesomeIcons.pencil,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      )
                    : Center(
                        child: GestureDetector(
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
                      ),

                SizedBox(
                  height: 20,
                ),
                // Divider(
                //     //height: 20,
                //     ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Personal details',
                    style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 14,
                    ),
                  ),
                ),
                showfname(),
                showlname(),
                showDropdown(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Professional Details',
                    style: TextStyle(
                      fontFamily: 'Manane',
                      fontSize: 14,
                    ),
                  ),
                ),

                showregion(),
                showdistr(),
                showhosp(),
                showspec(),
                showexp(),
                showbio(),
                Row(
                  children: [
                    Expanded(child: showstart()),
                    Expanded(child: showend()),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
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
                          colors: [Color(0xff1684A7), Color(0xff09A599)],
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
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
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
                          fontFamily: 'Poppins',
                          color: Color(0xff2E2E2E),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Lottie.asset(
                        'assets/heart.json',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Heebo',
                            color: Color(0xff7A828E),
                            fontSize: 12,
                          ),
                          "Oops! It seems like the email address or phone number is not correct. \nor this email is not registerd."),
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
                                color: Color(0xff344C9D),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: Text(
                              'Close',
                              style: TextStyle(
                                fontFamily: 'Heebo',
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
