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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
          centerTitle: false,
        ),
        body: inbox.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No any Message yet,',
                      style: TextStyle(
                        color: Color(0xff314165),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'Please book an appointment with doctors to start chatting.',
                      style: TextStyle(color: Color(0xff314165)),
                    ),
                    Lottie.asset(
                      'assets/loader.json',
                      width: 100,
                      height: 100,
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
                                      color: Color(0xff1684A7),
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  isThreeLine: true,
                                  //dense: true,
                                  subtitle: Text(inbox[index]['message'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  trailing: Text(
                                    result,
                                    style: TextStyle(
                                        color: Color(0xff314165), fontSize: 12),
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
