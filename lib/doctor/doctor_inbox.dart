import 'dart:async';
import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';

class InboxDoctor extends StatefulWidget {
  final receiverID;
  final senderID;
  final String clientName;
  const InboxDoctor(
      {super.key,
      required this.senderID,
      required this.receiverID,
      required this.clientName});

  @override
  State<InboxDoctor> createState() => _InboxDoctorState();
}

class _InboxDoctorState extends State<InboxDoctor> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  TextEditingController review = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Widget showreview() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: TextFormField(
            controller: review,
            validator: (val) => val!.isEmpty ? 'Say something' : null,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Heebo',
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
              hintText: "leave your review here ..",
              hintStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'Heebo',
                color: Color(0xff092058).withOpacity(0.25),
              ),
            )));
  }

  // Fetch otp api **************************
  double rate = 1.0;
  void postData() async {
    var url = Uri.parse('${Api.baseUrl}/send-review/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "doctor": widget.receiverID.toString(),
      "client": widget.senderID.toString(),
      "review": review.text,
      "rating": rate.toString()
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 201) {
      var iyoo = json.decode(response.body);

      review.clear();
      rate = 1.0;
      final data = context.read<ApiCalls>();

      data.fetchDoctor();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);

      //failMoadal();
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  void _submit() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      print(rate);
      showDialog(
          context: context,
          //barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Lottie.asset(
                  'assets/heart.json',
                  width: 90,
                  height: 90,
                ),
              ),
              // elevation: 10.0,
              backgroundColor: Colors.transparent,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
            );
          });
      postData();
    }
  }

  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final data = context.read<ApiCalls>();
      data.fetchInbox();
      data.fetchchat(widget.senderID, widget.receiverID);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uid = context.watch<ApiCalls>().currentUser;
    var messages = context.watch<ApiCalls>().mesage;
    DateFormat timeFormat = DateFormat('HH:mm');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.clientName),
          backgroundColor: const Color(0xff09A599),
          centerTitle: true,
        ),
        body: messages.isEmpty
            ? Center(
                child: Lottie.asset(
                  'assets/loader.json',
                  width: 100,
                  height: 100,
                ),
              )
            : Column(
                children: <Widget>[
                  // Chat messages display area
                  Expanded(
                      child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime =
                          DateTime.parse(messages[index]['date']).toLocal();

                      String formattedTime = timeFormat.format(dateTime);
                      return Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          int.parse(uid) == messages[index]['user']
                              ? Text('')
                              : Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff314165),
                                    ),
                                  ),
                                ),
                          Expanded(
                            child: Bubble(
                              margin: BubbleEdges.symmetric(
                                  horizontal: 15, vertical: 10),
                              stick: true,
                              alignment:
                                  int.parse(uid) == messages[index]['user']
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                              nip: int.parse(uid) == messages[index]['user']
                                  ? BubbleNip.leftBottom
                                  : BubbleNip.rightTop,
                              color: int.parse(uid) == messages[index]['user']
                                  ? Color(0xffF6EC72).withOpacity(0.5)
                                  : Color(0xff7743DB).withOpacity(0.5),
                              // style: styleSomebody,
                              child: Text(
                                messages[index]['message'],
                                style: TextStyle(
                                  //fontSize: 14,
                                  color: Color(0xff314165),
                                ),
                              ),
                            ),
                          ),
                          int.parse(uid) == messages[index]['user']
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff314165),
                                    ),
                                  ),
                                )
                              : Text(''),
                        ],
                      );
                    },
                  )),

                  // Divider line
                  Divider(height: 5.0),

                  // Message input area
                  _buildTextComposer(uid),
                ],
              ),
      ),
    );
  }

  Widget _buildTextComposer(userId) {
    return Container(
      color: const Color(0xff09A599),
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: <Widget>[
          // Text input field
          Expanded(
            child: TextFormField(
              controller: _textController,
              onChanged: (String messageText) {
                setState(() {
                  _isComposing = messageText.trim().isNotEmpty;
                });
              },
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.white),
              //expands: true,
              minLines: 1,
              maxLines: 3,
              //onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
          // Send button
          IconButton(
            icon: Icon(Icons.send,
                color: _isComposing ? const Color(0xffF6EC72) : Colors.white),
            onPressed: _isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String messageText) {
    String cleanedText = messageText.trim().replaceAll(RegExp(r'\s+'), ' ');
    //print(_textController.text);
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // Handle sending message logic here

    //print('text $cleanedText');
    sendmsg(messageText);
  }

  void sendmsg(msg) async {
    var uid = context.read<ApiCalls>().currentUser;
    var m = {
      "message": msg,
      "user": uid.toString(),
      "sender": widget.senderID.toString(),
      "reciever": widget.receiverID.toString()
    };

    var response = await http.post(
      Uri.parse(
        '${Api.baseUrl}/send-messages/',
      ),
      body: m,
    );

    // print(response.statusCode);
    if (response.statusCode == 201) {
      // List iyoo = json.decode(response.body);

      final data = context.read<ApiCalls>();
      data.fetchchat(widget.senderID, widget.receiverID);
      data.fetchInbox();
      FocusScope.of(context).unfocus();
    } else {
      //hama msg haijaend show errors
      FocusScope.of(context).unfocus();
      failMoadal();
    }
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manane',
                            color: Color(0xff314165),
                            fontSize: 12,
                          ),
                          "Oops! The message does not sent. \nPlease try again later "),
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
