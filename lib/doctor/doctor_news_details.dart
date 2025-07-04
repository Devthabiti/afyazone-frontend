import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';

class DoctorNewsDetails extends StatefulWidget {
  final Map data;
  const DoctorNewsDetails({super.key, required this.data});

  @override
  State<DoctorNewsDetails> createState() => _DoctorNewsDetailsState();
}

class _DoctorNewsDetailsState extends State<DoctorNewsDetails> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  @override
  void initState() {
    final data = context.read<ApiCalls>();

    data.fetcharticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var timestamp = widget.data['created_at'];
    var convertedTimestamp = DateTime.parse(timestamp).toLocal();
    var result = GetTimeAgo.parse(convertedTimestamp);
    var uid = context.watch<ApiCalls>().currentUser;

    //filter likes
    List lk = widget.data['postlikes'];
    List likes =
        lk.where((element) => element['client'] == int.parse(uid)).toList();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff09A599),
            title: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/logo.jpg'),
              ),
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      'Afyazone',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Icon(
                    Iconsax.verify5,
                    size: 15,
                    color: Colors.white,
                  ),
                ],
              ),
              //subtitle: Divider(),
              trailing: Text(
                result,
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ),
          ),
          body: Column(children: [
            Expanded(
              child: ListView(
                children: [
                  ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        CachedNetworkImage(
                          imageUrl: '${widget.data['image']}',
                          imageBuilder: (context, imageProvider) => Container(
                            child: Image(image: imageProvider),
                            // decoration: BoxDecoration(
                            //     image: DecorationImage(
                            //         image: imageProvider, fit: BoxFit.cover)),
                          ),
                          placeholder: (context, url) => Lottie.asset(
                            'assets/loader.json',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 5, top: 15),
                          child: Text(
                            widget.data['title'].toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tahoma',
                              color: Color(0xff314165), // Color(0xff1684A7),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 10,
                          ),
                          child: Text(
                            widget.data['content'],
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Tahoma',
                              color: Color(0xff314165),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                likes.isNotEmpty
                                    ? Container(
                                        height: 50,
                                        width: 40,
                                        // color: Colors.amber,
                                        child: Lottie.asset('assets/heart.json',
                                            repeat: false, fit: BoxFit.cover),
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(left: 5),
                                        height: 50,
                                        width: 40,
                                        // color: Colors.amber,
                                        child: Icon(
                                          Iconsax.heart,
                                          color: const Color(0xffF09A599),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Text(
                                    widget.data['likes'].toString(),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.messages_24,
                                  color: const Color(0xffF09A599),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(
                                    widget.data['comments'].length.toString(),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.eye,
                                  color: const Color(0xffF09A599),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(
                                    widget.data['views'].toString(),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ]),
                  //hapa list view nyingine
                  widget.data['comments'].isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'No any Comment yet',
                              style: TextStyle(
                                color: Color(0xff314165),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.data['comments'].length,
                          itemBuilder: (context, index) {
                            var timestamp =
                                widget.data['comments'][index]['created_at'];
                            var convertedTimestamp =
                                DateTime.parse(timestamp).toLocal();
                            var result = GetTimeAgo.parse(convertedTimestamp);
                            return ListTile(
                              leading: widget.data['comments'][index]
                                          ['client_profile']['image'] ==
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: widget.data['comments']
                                                      [index]['client_profile']
                                                  ['gender'] ==
                                              "Male"
                                          ? AssetImage('assets/man.png')
                                          : AssetImage('assets/woman.png'),
                                      radius: 20,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          '${Api.baseUrl}${widget.data['comments'][index]['client_profile']['image']}',
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 20,
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                    ),
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Text(
                                      widget.data['comments'][index]
                                          ['client_profile']['username'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff09A599),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    result,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff314165),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                widget.data['comments'][index]['content'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Manane',
                                ),
                              ),
                            );
                          })
                ],
              ),
            ),
          ])),
    );
  }
}
