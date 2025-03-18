import 'dart:async';

import 'package:afya/messages/inbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/providers/token_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // void searchArticles(String query) {
  //   var inbo = context.read<ApiCalls>().myInbox;
  //   final sug = inbo.where((chat) {
  //     var fname = chat['reciever_profile']['first_name'].toLowerCase();
  //     var lname = chat['reciever_profile']['last_name'].toLowerCase();

  //     var input = query.toLowerCase();
  //     return fname.contains(input) || lname.contains(input);
  //   }).toList();
  //   setState(() {
  //     inbox = sug;
  //   });
  // }

  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final data = context.read<ApiCalls>();
      data.fetchInbox();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inbox = context.read<ApiCalls>().myInbox;
    print(inbox);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xffFFFFFF),
          title: Text(
            'Messages',
            style: TextStyle(
              color: Color(0xff262626),
              //fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: inbox.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No any Message yet,',
                      style: TextStyle(
                          color: Color(0xff262626),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'Please book an appointment with doctors to start chatting.',
                      style: TextStyle(color: Color(0xff262626), fontSize: 12),
                    ),
                    // Lottie.asset(
                    //   'assets/loader.json',
                    //   width: 100,
                    //   height: 100,
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      // onTap: _submit,
                      child: Container(
                        height: 40,
                        width: 120,
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
                            'Start Now',
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
              )
            : Column(
                children: [
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  //   height: 50,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       color: const Color(0xffF6EC72),
                  //       borderRadius: BorderRadius.circular(7)),
                  //   child: TextFormField(
                  //     style: TextStyle(color: Color(0xff314165)),
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       hintText: "Search for a chat",
                  //       hintStyle: TextStyle(color: Color(0xff314165)),
                  //       suffixIcon:
                  //           Icon(Icons.search, color: Color(0xff314165)),
                  //     ),
                  //     onChanged: searchArticles,
                  //   ),

                  // ),
                  Divider(),
                  Expanded(
                      child: ListView.builder(
                          itemCount: inbox.length,
                          itemBuilder: (context, index) {
                            var timestamp = inbox[index]['date'];
                            var convertedTimestamp = DateTime.parse(timestamp)
                                .toLocal(); // Converting into [DateTime] object
                            var result = GetTimeAgo.parse(convertedTimestamp);
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    final data = context.read<ApiCalls>();
                                    data.fetchchat(
                                        inbox[index]['sender_profile']['user'],
                                        inbox[index]['reciever_profile']
                                            ['user']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InboxPage(
                                                  senderID: inbox[index]
                                                          ['sender_profile']
                                                      ['user'],
                                                  receiverID: inbox[index]
                                                          ['reciever_profile']
                                                      ['user'],
                                                  lastSeen: inbox[index]
                                                          ['reciever_profile']
                                                      ['last_seen'],
                                                  onlineStatus: inbox[index]
                                                          ['reciever_profile']
                                                      ['is_online'],
                                                  doctorName:
                                                      'Dr ${inbox[index]['reciever_profile']['first_name']} ${inbox[index]['reciever_profile']['last_name']}',
                                                )));
                                  },
                                  leading: CachedNetworkImage(
                                    imageUrl:
                                        '${inbox[index]['reciever_profile']['image']}',
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 25,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                  ),
                                  title: Text(
                                    'Dr ${inbox[index]['reciever_profile']['first_name']}',
                                    style: TextStyle(
                                        color: Color(0xff262626),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  isThreeLine: true,
                                  //dense: true,
                                  subtitle: Text(inbox[index]['message'],
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Color(0xff262626),
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis),
                                  trailing: Text(
                                    result,
                                    style: TextStyle(
                                        color:
                                            Color(0xff262626).withOpacity(0.5),
                                        fontSize: 12),
                                  ),
                                ),
                                Divider(
                                  indent: 60,
                                )
                              ],
                            );
                          }))
                ],
              ),
      ),
    );
  }
}
