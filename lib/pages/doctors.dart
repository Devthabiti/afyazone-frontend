import 'package:afya/doctor/doctor_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../doctor/doctor_image.dart';
import '../models/providers/token_provider.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  Widget search() {
    return Container(
      width: 300,
      height: 40,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.only(
          left: 30,
        ),
        child: TextFormField(
          style: TextStyle(color: Color(0xff262626).withOpacity(0.5)),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: "Search for doctors",
            hintStyle: TextStyle(color: Color(0xff262626).withOpacity(0.5)),
            prefixIcon:
                Icon(Icons.search, color: Color(0xff262626).withOpacity(0.5)),
          ),
          onChanged: searchArticles,
        ),
      ),

      // child: TextFormField(
      //   decoration: InputDecoration(
      //     border: OutlineInputBorder(
      //       // borderRadius: BorderRadius.circular(10),
      //       borderSide: BorderSide.none,
      //     ),
      //     hintText: 'Search Product',
      //     filled: true,
      //     prefixIcon: Icon(
      //       Icons.search,
      //     ),
      //     suffixIcon: Icon(
      //       Icons.close,
      //     ),
      //   ),
      // ),
    );
  }

  double rate = 1.0;

  List doctors = [];
  void searchArticles(String query) {
    var dr = context.read<ApiCalls>().allDoctors;
    final sug = dr.where((doctor) {
      var firstname = doctor['first_name'].toLowerCase();
      var lastname = doctor['last_name'].toLowerCase();
      var region = doctor['region'].toLowerCase();
      var hospital = doctor['hospital'].toLowerCase();
      var specialize = doctor['specialize'].toLowerCase();

      var input = query.toLowerCase();
      return firstname.contains(input) ||
          lastname.contains(input) ||
          region.contains(input) ||
          hospital.contains(input) ||
          specialize.contains(input);
    }).toList();
    setState(() {
      doctors = sug;
    });
  }

  @override
  void initState() {
    final data = context.read<ApiCalls>();
    data.fetchDoctor();
    doctors = context.read<ApiCalls>().allDoctors;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var doctors = context.watch<ApiCalls>().allDoctors;
    print(doctors);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: const Color(0xffFFFFFF),
          appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: const Color(0xffFFFFFF),
              elevation: 1,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: search()),
          body: doctors.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/loader.json',
                    width: 100,
                    height: 100,
                  ),
                )
              : ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorProfile(
                                      doctor: doctors[index],
                                    )));
                      },
                      child: Card(
                        color: const Color(0xffFFFFFF),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: GestureDetector(
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
                                      CircleAvatar(
                                    radius: 25,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                ),
                              ),
                              title: Text(
                                'Dr ${doctors[index]['first_name']}  ${doctors[index]['last_name']}',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    color: const Color(0xff262626),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                ' ${doctors[index]['specialize']}',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color:
                                      const Color(0xff262626).withOpacity(0.6),
                                ),
                              ),
                              trailing: Container(
                                  width: 70,
                                  //color: Colors.amber,
                                  child: doctors[index]['is_online']
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.online_prediction,
                                              size: 20,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Online',
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                color: const Color(0xff262626),
                                                fontSize: 14,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.online_prediction,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Offline',
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                color: const Color(0xff262626),
                                                fontSize: 14,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color(0xff0071e7).withOpacity(0.6)),
                              child: Center(
                                  child: Text(
                                'Works at ${doctors[index]['hospital']}',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color: Colors.white,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            ListTile(
                              title: Text(
                                'Availability',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    color: const Color(0xff262626),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${doctors[index]['start_day']} - ${doctors[index]['end_day']}',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color:
                                      const Color(0xff262626).withOpacity(0.6),
                                ),
                              ),
                              trailing: Text(
                                'TZS ${doctors[index]['price']}/= per person',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color:
                                      const Color(0xff262626).withOpacity(0.6),
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Level of Profession',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    color: const Color(0xff262626),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Container(
                                // color: Colors.amber,
                                width: 120,
                                child: doctors[index]['doctor_level'] == null
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RatingBar.builder(
                                              initialRating: 1,
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
                                              '( EN )',
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                fontSize: 12,
                                                color: const Color(0xff262626),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RatingBar.builder(
                                              initialRating: doctors[index]
                                                  ['doctor_level']['value'],

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
                                              doctors[index]['doctor_level']
                                                  ['level_type'],
                                              style: TextStyle(
                                                fontFamily: 'Manane',
                                                fontSize: 12,
                                                color: const Color(0xff262626),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              trailing: Text(
                                'Total Patient : ${doctors[index]['patient'].length}',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color:
                                      const Color(0xff262626).withOpacity(0.6),
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
