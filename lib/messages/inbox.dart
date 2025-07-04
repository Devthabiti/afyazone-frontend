import 'dart:async';
import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';

class InboxPage extends StatefulWidget {
  final receiverID;
  final senderID;
  final String doctorName;
  final bool onlineStatus;
  final String lastSeen;
  const InboxPage(
      {super.key,
      required this.senderID,
      required this.receiverID,
      required this.onlineStatus,
      required this.lastSeen,
      required this.doctorName});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
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
              color: Color(0xff262626),
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
                color: Color(0xff262626).withOpacity(0.25),
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

  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final data = context.read<ApiCalls>();
      data.fetchInbox();
      data.fetchchat(widget.senderID, widget.receiverID);
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _textController.dispose();
    super.dispose();
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

//getting 1 v 1 message

  @override
  Widget build(BuildContext context) {
    var uid = context.watch<ApiCalls>().currentUser;
    var messages = context.watch<ApiCalls>().mesage;
    DateFormat timeFormat = DateFormat('HH:mm');

    var convertedTimestamp = DateTime.parse(widget.lastSeen)
        .toLocal(); // Converting into [DateTime] object
    var result = GetTimeAgo.parse(convertedTimestamp);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: const Color(0xffFFFFFF),
          appBar: AppBar(
            backgroundColor: const Color(0xffFFFFFF),
            toolbarHeight: 80,
            title: Column(
              children: [
                Text(
                  widget.doctorName,
                  style: TextStyle(
                    color: Color(0xff262626),
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                widget.onlineStatus
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 14,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: Color(0xff262626),
                              fontSize: 14,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Last Seen $result',
                        style: TextStyle(
                          color: Color(0xff262626),
                          fontSize: 12,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
            centerTitle: true,
            elevation: 1,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Color(0xff262626),
                )),
            actions: [
              IconButton(
                onPressed: mydialog,
                icon: Icon(
                  Iconsax.star1,
                  size: 25,
                  color: Color(0xff0071e7),
                ),
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          body: messages.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/loader.json',
                    width: 100,
                    height: 100,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bgb.jpg'),
                        fit: BoxFit.cover,
                        opacity: 0.25),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: GroupedListView<dynamic, String>(
                        elements: messages,
                        groupBy: (element) {
                          DateTime dateTime =
                              DateTime.parse(element['date']).toLocal();

                          return dateTime.day.toString();
                        },
                        groupHeaderBuilder: (element) {
                          DateTime dateTime =
                              DateTime.parse(element['date']).toLocal();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Bubble(
                              stick: true,
                              alignment: Alignment.center,
                              color: Color.fromARGB(255, 184, 222, 240),
                              child: Text(
                                DateFormat.yMMMd().format(dateTime),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xff262626),
                                  fontSize: 12,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (c, element) {
                          DateTime dateTime =
                              DateTime.parse(element['date']).toLocal();
                          String formattedTime = timeFormat.format(dateTime);
                          return Row(
                            children: [
                              int.parse(uid) == element['user']
                                  ? Text('')
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: Color(0xff262626),
                                          fontSize: 10,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              Expanded(
                                child: Bubble(
                                  elevation: 1,
                                  shadowColor: Colors.grey,
                                  margin: BubbleEdges.all(15),
                                  color: int.parse(uid) == element['user']
                                      ? Color.fromRGBO(225, 255, 199, 1.0)
                                      : Color.fromARGB(255, 236, 241, 245),
                                  alignment: int.parse(uid) == element['user']
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Text(
                                    element['message'],
                                  ),
                                ),
                                //  Container(
                                //   padding: EdgeInsets.all(15),
                                //   margin: EdgeInsets.all(20),
                                //   // width: 200,

                                //   // alignment: int.parse(uid) == element['user']
                                //   //     ? Alignment.topRight
                                //   //     : Alignment.topLeft,
                                //   decoration: BoxDecoration(
                                //       color: Colors.amber,
                                //       borderRadius: BorderRadius.circular(15)),

                                //   child: Text(
                                //     element['message'],
                                //   ),
                                // ),
                              ),
                              int.parse(uid) == element['user']
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: Color(0xff262626),
                                          fontSize: 10,
                                          //fontWeight: FontWeight.bold,
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
                )

          // : Column(
          //     children: <Widget>[
          //       // Chat messages display area
          //       Expanded(
          //           child: ListView.builder(
          //         itemCount: messages.length,
          //         itemBuilder: (context, index) {
          //           DateTime dateTime =
          //               DateTime.parse(messages[index]['date']).toLocal();

          //           String formattedTime = timeFormat.format(dateTime);
          //           return Row(
          //             //mainAxisAlignment: MainAxisAlignment.start,
          //             // crossAxisAlignment: CrossAxisAlignment.stretch,
          //             children: [
          //               int.parse(uid) == messages[index]['user']
          //                   ? Text('')
          //                   : Padding(
          //                       padding: const EdgeInsets.only(left: 10),
          //                       child: Text(
          //                         formattedTime,
          //                         style: TextStyle(
          //                           fontSize: 10,
          //                           color: Color(0xff314165),
          //                         ),
          //                       ),
          //                     ),
          //               Expanded(
          //                 child: Bubble(
          //                   margin: BubbleEdges.symmetric(
          //                       horizontal: 15, vertical: 10),
          //                   stick: true,
          //                   alignment:
          //                       int.parse(uid) == messages[index]['user']
          //                           ? Alignment.topRight
          //                           : Alignment.topLeft,
          //                   nip: int.parse(uid) == messages[index]['user']
          //                       ? BubbleNip.leftBottom
          //                       : BubbleNip.rightTop,
          //                   color: int.parse(uid) == messages[index]['user']
          //                       ? Color(0xffF6EC72).withOpacity(0.5)
          //                       : Color(0xff7743DB).withOpacity(0.5),
          //                   // style: styleSomebody,
          //                   child: Text(
          //                     messages[index]['message'],
          //                     style: TextStyle(
          //                       //fontSize: 14,
          //                       color: Color(0xff314165),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               int.parse(uid) == messages[index]['user']
          //                   ? Padding(
          //                       padding: const EdgeInsets.only(right: 10.0),
          //                       child: Text(
          //                         formattedTime,
          //                         style: TextStyle(
          //                           fontSize: 10,
          //                           color: Color(0xff314165),
          //                         ),
          //                       ),
          //                     )
          //                   : Text(''),
          //             ],
          //           );
          //         },
          //       )),

          //       // Divider line
          //       Divider(height: 5.0),

          //       // Message input area
          //       _buildTextComposer(uid),
          //     ],
          //   ),
          ),
    );
  }

  final FocusNode focus = FocusNode();
  Widget _buildTextComposer(userId) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focus);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 1.0, // Spread radius of the shadow
              blurRadius: 4.0, // Blur radius of the shadow
              offset: Offset(0, -1), // Offset of the shadow (x, y)
            ),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: <Widget>[
            // Text input field
            Expanded(
              child: TextFormField(
                focusNode: focus,
                controller: _textController,
                onChanged: (String messageText) {
                  setState(() {
                    _isComposing = messageText.trim().isNotEmpty;
                  });
                },
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Color(0xff262626)),
                //expands: true,
                minLines: 1,
                maxLines: 3,
                //onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                    hintText: 'Send a message',
                    hintStyle:
                        TextStyle(color: Color(0xff262626), fontSize: 16)),
              ),
            ),
            // Send button
            Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 5),
              child: CircleAvatar(
                backgroundColor:
                    _isComposing ? const Color(0xfffe0002) : Color(0xff0071e7),
                radius: 20,
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                ),
              ),
            ),
          ],
        ),
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
                  initialChildSize: 0.7,
                  minChildSize: 0.6,
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
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Lottie.asset(
                                  'assets/ratings.json',
                                  width: 170,
                                  height: 170,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Rating",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff262626),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RatingBar.builder(
                                  initialRating: rate,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  //itemSize: 35,
                                  //ignoreGestures: true,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Color(0xff0071e7),
                                  ),
                                  onRatingUpdate: (rating) {
                                    rate = rating;
                                    // print(rate);
                                  },
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
                                          EdgeInsets.only(left: 15.0, top: 15),
                                      child: Text(
                                        'Comments',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff262626)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    showreview(),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: _submit,
                                        child: Container(
                                          height: 45,
                                          width: 180,
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
                                              'Send Review',
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

// class CallPage extends StatelessWidget {
//   const CallPage(
//       {Key? key,
//       required this.callID,
//       required this.userId,
//       required this.userName})
//       : super(key: key);
//   final String callID;
//   final String userId;
//   final String userName;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: 1324622238,
//       appSign:
//           '74a6ac0ab735293c0138def5e5ab7f7dab7d81b614a2bedd845ada06587bff2d',
//       userID: 'user_id',
//       userName: 'user_name',
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//     );
//   }
// }
