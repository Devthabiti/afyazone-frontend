import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/providers/token_provider.dart';
import 'doctor_image.dart';

class DoctorYaProfile extends StatefulWidget {
  final doctor;
  const DoctorYaProfile({super.key, required this.doctor});

  @override
  State<DoctorYaProfile> createState() => _DoctorYaProfileState();
}

class _DoctorYaProfileState extends State<DoctorYaProfile> {
  TextEditingController phone = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Widget showphone() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: phone,
            validator: (val) =>
                val!.length < 10 ? 'Complete Phone Number' : null,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Heebo',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              hintText: "Enter Your Payment Number",
              hintStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'Heebo',
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    DateFormat timeFormat = DateFormat('HH:mm');

    print(widget.doctor['bio']);
    return Scaffold(
      // appBar: AppBar(
      //     toolbarHeight: 100,
      //     automaticallyImplyLeading: false,
      //     backgroundColor: const Color(0xff09A599),
      //     title: ListTile(
      //       leading: GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => ImageViewPage(
      //                       name:
      //                           'Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']}',
      //                       imageUrl:
      //                           'http://157.230.183.103${widget.doctor['image']}')));
      //         },
      //         child: CachedNetworkImage(
      //           imageUrl: 'http://157.230.183.103${widget.doctor['image']}',
      //           imageBuilder: (context, imageProvider) => CircleAvatar(
      //             radius: 25,
      //             backgroundImage: imageProvider,
      //           ),
      //           placeholder: (context, url) => CircularProgressIndicator(),
      //         ),
      //       ),
      //       title: Text(
      //         'Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']}',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //       subtitle: Text(
      //         '${widget.doctor['specialize']}',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     )),
      body: SingleChildScrollView(
        child: Column(children: [
          CachedNetworkImage(
            imageUrl: 'http://157.230.183.103${widget.doctor['image']}',
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff09A599).withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${widget.doctor['experience']} Years',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Experience',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.doctor['patient'].length}',
                                style: TextStyle(
                                    fontFamily: 'Manane',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Patients',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              widget.doctor['review'].isEmpty
                                  ? Text(
                                      '0',
                                      style: TextStyle(
                                          fontFamily: 'Manane',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '${widget.doctor['review'].length}',
                                      style: TextStyle(
                                          fontFamily: 'Manane',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Reviews',
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
          ),
          const SizedBox(
            height: 15,
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff09A599).withOpacity(0.25)),
                  child: Center(
                      child: Text(
                    'Works at ${widget.doctor['hospital']}',
                    style: TextStyle(
                        color: Color(0xff314165),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                ListTile(
                  title: Text(
                    'Availability',
                    style: TextStyle(
                        fontFamily: 'Manane',
                        color: const Color(0xff09A599).withOpacity(0.65),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${widget.doctor['start_day']}- ${widget.doctor['end_day']}'),
                  trailing: Text(
                    'TZS ${widget.doctor['price']}/= per person',
                    style: TextStyle(
                      fontFamily: 'Manane',
                      color: Color(0xff314165),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Specialize on'),
                      Text(
                        '${widget.doctor['specialize']}',
                        style: TextStyle(
                            fontFamily: 'Manane',
                            color: const Color(0xff09A599).withOpacity(0.65),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Location'),
                      Text(
                        '${widget.doctor['region']} - ${widget.doctor['district']}',
                        style: TextStyle(
                            fontFamily: 'Manane',
                            color: const Color(0xff09A599).withOpacity(0.65),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'About Doctor',
              style: TextStyle(
                  fontFamily: 'Manane',
                  color: Color(0xff314165),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: const Color(0xff09A599).withOpacity(0.25),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              widget.doctor['bio'],
              style: TextStyle(
                fontFamily: 'Manane',
                color: Color(0xff314165),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Reviews',
              style: TextStyle(
                  fontFamily: 'Manane',
                  fontSize: 16,
                  color: Color(0xff314165),
                  fontWeight: FontWeight.bold),
            ),
          ),
          widget.doctor['review'].isEmpty
              ? Container(
                  height: 200,
                  width: double.infinity,
                  //color: Colors.amber,
                  child: Center(
                      child: Text('No review yet',
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff314165),
                          ))),
                )
              : ListView.builder(
                  itemCount: widget.doctor['review'].length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(
                            widget.doctor['review'][index]['created'])
                        .toLocal();
                    String formattedDate = dateFormat.format(dateTime);
                    String formattedTime = timeFormat.format(dateTime);
                    return Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          ListTile(
                            leading: widget.doctor['review'][index]
                                        ['client_profile']['image'] ==
                                    null
                                ? CircleAvatar(
                                    backgroundImage: widget.doctor['review']
                                                    [index]['client_profile']
                                                ['gender'] ==
                                            "Male"
                                        ? AssetImage('assets/man.png')
                                        : AssetImage('assets/woman.png'),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        'http://157.230.183.103${widget.doctor['review'][index]['client_profile']['image']}',
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => CircleAvatar(
                                      backgroundColor: const Color(0xffF6EC72),
                                    ),
                                  ),
                            title: Text(
                                widget.doctor['review'][index]['client_profile']
                                    ['username'],
                                style: TextStyle(
                                  fontFamily: 'Manane',
                                  color: Color(0xff314165),
                                )),
                            subtitle:
                                Text(widget.doctor['review'][index]['review']),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 40,
                            color: const Color(0xff09A599).withOpacity(0.25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RatingBar.builder(
                                  initialRating: widget.doctor['review'][index]
                                      ['rating'],
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 15,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 10,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                Text('$formattedDate | $formattedTime',
                                    style: TextStyle(
                                      color: Color(0xff314165),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
        ]),
      ),
    );
  }
}
