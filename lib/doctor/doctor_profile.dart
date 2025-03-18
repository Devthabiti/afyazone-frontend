import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:afya/messages/inbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/providers/token_provider.dart';
import 'doctor_image.dart';
import 'package:http/http.dart' as http;

class DoctorProfile extends StatefulWidget {
  final doctor;
  const DoctorProfile({super.key, required this.doctor});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
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
              color: Color(0xff262626),
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
                color: Color(0xff262626).withOpacity(0.25),
              ),
            )));
  }

  void sendmsg() async {
    var uid = context.read<ApiCalls>().currentUser;
    var data = context.read<ApiCalls>().clientData;

    String msg =
        "Habari, ${data['username']}! \nKaribu kwa ushauri,Jisikie huru kuniuliza jambo lolote kuhusu afya. \n\n(Huenda sipo online muda huu hivyo nitakujibu pindi tu ntakapokua online.) \nTafadhali endelea kusubiri";
    var m = {
      "message": msg,
      "user": widget.doctor['user'].toString(),
      "sender": uid.toString(),
      "reciever": widget.doctor['user'].toString()
    };

    var response = await http.post(
      Uri.parse(
        'http://157.230.183.103/send-messages/',
      ),
      body: m,
    );

    // print(response.statusCode);
    if (response.statusCode == 201) {
      // List iyoo = json.decode(response.body);

      final data = context.read<ApiCalls>();
      data.fetchchat(uid, widget.doctor['user']);
      data.fetchInbox();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => InboxPage(
                  senderID: uid,
                  receiverID: widget.doctor['user'].toString(),
                  lastSeen: widget.doctor['last_seen'],
                  onlineStatus: widget.doctor['is_online'],
                  doctorName:
                      'Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']}')),
          (route) => false);
    }
  }

  final Random _random = Random();
  postOrder() async {
    String orderIds = _random.nextInt(9000000).toString().padLeft(7, '0');
    var url = Uri.parse('https://api.zeno.africa');

    // Defined request body
    var body = {
      'create_order': orderIds,
      'buyer_email': 'sideukas@gmail.com',
      'buyer_name': 'afyazone',
      'buyer_phone': phone.text,
      'amount': widget.doctor['price'].toString(),
      'account_id': 'zp44340',
      'api_key': 'ded13c0d740c577f9c44a3f8e2759ea3',
      'secret_key':
          'b897d25736d5e2a1947aebc9a6a0bb87cf66a60904fabdd81a20a323cff4b723'
    };

    // POST request
    var response = await http.post(
      url,
      body: body,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var iyoo = json.decode(response.body);

      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        fetchStatus(
          iyoo['order_id'],
        );
      });
    } else {
      Navigator.pop(context);
      failMoadal();
    }
  }

  void fetchStatus(orderId) async {
    var url = Uri.parse('https://api.zeno.africa/order-status');

    // Defined request body
    var statusData = {
      'check_status': '90567',
      'order_id': orderId,
      'api_key': 'ded13c0d740c577f9c44a3f8e2759ea3',
      'secret_key':
          'b897d25736d5e2a1947aebc9a6a0bb87cf66a60904fabdd81a20a323cff4b723'
    };

    // POST request
    var response = await http.post(
      url,
      body: statusData,
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      var iyoo = json.decode(response.body);

      if (iyoo['payment_status'] == 'COMPLETED') {
        // send data to my backend
        postData(orderId);
      }
    }
  }

//post data
  void postData(id) async {
    var uid = context.read<ApiCalls>().currentUser;
    var url = Uri.parse('http://157.230.183.103/create-transaction/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      'client': uid,
      'doctor': widget.doctor['user'].toString(),
      'payment_phone': phone.text,
      'order_id': id,
      'amount': widget.doctor['price'].toString()
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    // Check the status code of the response
    if (response.statusCode == 201) {
      sendmsg();
    }
  }

  void submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      showDialogy();
      //sendmsg();
      postOrder();
    }
  }

  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {});
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    DateFormat timeFormat = DateFormat('HH:mm');

    var miamala = context.watch<ApiCalls>().transactions;
    var uid = context.watch<ApiCalls>().currentUser;
    List trans = miamala
        .where((element) =>
            element['client'] == int.parse(uid) &&
            element['doctor'] == widget.doctor['user'])
        .toList();

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: trans.isEmpty
            ? Container(
                child: Center(
                  child: GestureDetector(
                    onTap: mydialog,
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
                          'CHAT WITH DOCTOR',
                          style: TextStyle(
                              fontFamily: 'Manane',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InboxPage(
                                  senderID: uid,
                                  receiverID: widget.doctor['user'].toString(),
                                  lastSeen: widget.doctor['last_seen'],
                                  onlineStatus: widget.doctor['is_online'],
                                  doctorName:
                                      'Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']}')));
                    },
                    child: Container(
                      height: 45,
                      width: 130,
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
                          'CHAT ',
                          style: TextStyle(
                              fontFamily: 'Manane',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        height: 100,
        elevation: 10,
      ),
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
                      Color(0xff0071e7).withOpacity(0.4),
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
                          'Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']}'
                              .toUpperCase(),
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
            placeholder: (context, url) => CircularProgressIndicator(
              color: Color(0xff0071e7),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff0071e7).withOpacity(0.6)),
                child: Center(
                    child: Text(
                  'Works at ${widget.doctor['hospital']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
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
                  '${widget.doctor['start_day']}- ${widget.doctor['end_day']}',
                  style: TextStyle(
                    fontFamily: 'Manane',
                    color: const Color(0xff262626).withOpacity(0.6),
                  ),
                ),
                trailing: Text(
                  'TZS ${widget.doctor['price']}/= per person',
                  style: TextStyle(
                    fontFamily: 'Manane',
                    color: const Color(0xff262626).withOpacity(0.6),
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Specialize on',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      color: const Color(0xff262626),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.doctor['specialize']}',
                  style: TextStyle(
                    fontFamily: 'Manane',
                    color: const Color(0xff262626).withOpacity(0.6),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                      fontFamily: 'Manane',
                      color: const Color(0xff262626),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Region : ${widget.doctor['region']}',
                      style: TextStyle(
                        fontFamily: 'Manane',
                        color: const Color(0xff262626).withOpacity(0.6),
                      ),
                    ),
                    Text(
                      'District : ${widget.doctor['district']}',
                      style: TextStyle(
                        fontFamily: 'Manane',
                        color: const Color(0xff262626).withOpacity(0.6),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'About Doctor',
              style: TextStyle(
                  fontFamily: 'Manane',
                  color: Color(0xff262626),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: const Color(0xff0071e7).withOpacity(0.25),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              widget.doctor['bio'],
              style: TextStyle(
                fontFamily: 'Manane',
                color: Color(0xff262626),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Reviews',
                style: TextStyle(
                    fontFamily: 'Manane',
                    color: Color(0xff262626),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
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
                            color: Color(0xff262626),
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
                                  color: Color(0xff262626),
                                )),
                            subtitle:
                                Text(widget.doctor['review'][index]['review']),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 40,
                            color: const Color(0xff0071e7).withOpacity(0.25),
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
                                      fontFamily: 'Manane',
                                      color: Color(0xff262626),
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

  mydialog() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.4,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Form(
                      key: formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 25.0,
                              ),
                              Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Payment for doctor's consultation.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xff262626),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 15),
                                child: Text(
                                  "To chat with Dr ${widget.doctor['first_name']} ${widget.doctor['last_name']} , you must first pay TZS ${widget.doctor['price']}/= Please note, this is not treatment but rather doctor's advice.",
                                  style: TextStyle(
                                    color: Color(0xff262626).withOpacity(0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(15),
                                width: double.infinity,
                                //height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 20.0, top: 15),
                                      child: Text(
                                        'Payment Number',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff262626),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    showphone(),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: submit,
                                        child: Container(
                                          height: 45,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff0071e7),
                                                Color(0xff262626)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode
                                                  .clamp, // This is the default
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Pay TZS ${widget.doctor['price']}/=',
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
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  showDialogy() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Payment Confimations',
              style: TextStyle(
                  fontFamily: 'Manane',
                  color: Color(0xff262626),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              children: [
                Text(
                    style: TextStyle(
                      fontFamily: 'Manane',
                      color: Color(0xff262626).withOpacity(0.6),
                    ),
                    '1. You will receive a prompt from your  mobile money enter your PIN to approve the amount to be deducted.\n\n2. Please Enter your mobile money PIN'),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  height: 50,
                  width: double.infinity,
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
                      child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Lottie.asset(
                          'assets/load.json',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Text(
                        'Awaiting confirmation',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ],
            ),

            elevation: 10.0,

            // backgroundColor: Colors.amber,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
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
                          "Oops! Payment was not completed. \nPlease try again later "),
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
