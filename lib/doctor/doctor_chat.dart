import 'dart:async';

import 'package:afya/doctor/doctor_inbox.dart';
import 'package:afya/messages/inbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/providers/token_provider.dart';

class ChatDoctor extends StatefulWidget {
  const ChatDoctor({super.key});

  @override
  State<ChatDoctor> createState() => _ChatDoctorState();
}

class _ChatDoctorState extends State<ChatDoctor> {
  late Timer _timer;
  @override
  void initState() {
    final data = context.read<ApiCalls>();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
    var inbox = context.watch<ApiCalls>().myInbox;
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: const Color(0xff09A599),
        centerTitle: false,
      ),
      body: inbox.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No any Message yet',
                    style: TextStyle(
                      color: Color(0xff314165),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
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
                                      inbox[index]['reciever_profile']['user']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InboxDoctor(
                                                senderID: inbox[index]
                                                    ['sender_profile']['user'],
                                                receiverID: inbox[index]
                                                        ['reciever_profile']
                                                    ['user'],
                                                clientName:
                                                    '${inbox[index]['sender_profile']['username']}',
                                              )));
                                },
                                leading: inbox[index]['sender_profile']
                                            ['image'] ==
                                        null
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundImage: inbox[index]
                                                        ['sender_profile']
                                                    ['gender'] ==
                                                "Male"
                                            ? AssetImage('assets/man.png')
                                            : AssetImage('assets/woman.png'),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            '${inbox[index]['sender_profile']['image']}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 25,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                      ),
                                title: Text(
                                  '${inbox[index]['sender_profile']['username']}',
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
                                trailing: Text(result,
                                    style: TextStyle(
                                        color: Color(0xff314165),
                                        fontSize: 12)),
                              ),
                              Divider(
                                indent: 60,
                              )
                            ],
                          );
                        }))
              ],
            ),
    );
  }
}
