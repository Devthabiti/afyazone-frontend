import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';

class NewsDetails extends StatefulWidget {
  final Map data;
  const NewsDetails({super.key, required this.data});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  // Fetch otp api **************************

  void postData(postId, clientId) async {
    var url = Uri.parse('${Api.baseUrl}/likes/');

    // Defined headers
    Map<String, String> headers = {
      //'Authorization': 'Basic bWF0aWt1OmJpcGFzMTIzNA==',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Defined request body
    var body = {
      "post_id": postId.toString(),
      "client_id": clientId.toString(),
    };

    // POST request
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
      //encoding: Encoding.getByName('utf-8'),
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      final data = context.read<ApiCalls>();
      data.fetchMostViews();
      data.fetchMostLiked();
      getDetails();
    }
  }

  @override
  void initState() {
    getDetails();
    final data = context.read<ApiCalls>();
    data.fetcharticles();
    super.initState();
  }

  //fetching Most 10 articles with views
  Map likeData = {};
  List likes = [];
  getDetails() async {
    var uid = context.read<ApiCalls>().currentUser;
    var response = await http.get(
      Uri.parse('${Api.baseUrl}/show-article-details/${widget.data['id']}/'),
    );
    if (response.statusCode == 200) {
      likeData = json.decode(utf8.decode(response.bodyBytes));
      if (likeData.isNotEmpty) {
        List lk = likeData['postlikes'];
        likes =
            lk.where((element) => element['client'] == int.parse(uid)).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var timestamp = widget.data['created_at'];
    var convertedTimestamp = DateTime.parse(timestamp).toLocal();
    var result = GetTimeAgo.parse(convertedTimestamp);
    var uid = context.watch<ApiCalls>().currentUser;

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
                      style: TextStyle(
                        color: Color(0xff262626),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      Iconsax.verify5,
                      size: 12,
                      color: Color(0xff0071e7),
                    ),
                  ),
                ],
              ),
              //subtitle: Divider(),
              trailing: Text(
                result,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xff262626),
                ),
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              //fontFamily: 'Tahoma',
                              color: Color(0xff262626),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                              color: Color(0xff262626),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        likeData.isEmpty
                            ? Center(
                                child: Lottie.asset(
                                'assets/loader.json',
                                width: 70,
                                height: 70,
                              ))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      likes.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                postData(
                                                    widget.data['id'], uid);
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 40,
                                                //color: Colors.amber,
                                                child: Lottie.asset(
                                                    'assets/heart.json',
                                                    repeat: false,
                                                    fit: BoxFit.cover),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                postData(
                                                    widget.data['id'], uid);
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                height: 50,
                                                width: 40,
                                                // color: Colors.amber,
                                                child: Icon(
                                                  Iconsax.heart,
                                                  color: Color(0xff262626),
                                                ),
                                              ),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: Text(
                                            style: TextStyle(
                                              color: Color(0xff262626),
                                              fontSize: 14,
                                            ),
                                            NumberFormat.compact()
                                                .format(likeData['likes'])
                                            // likeData['likes'].toString(),
                                            ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.messages_24,
                                        color: Color(0xff262626),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                            style: TextStyle(
                                              color: Color(0xff262626),
                                              fontSize: 14,
                                            ),
                                            NumberFormat.compact().format(
                                                likeData['comments'].length)
                                            // likeData['comments']
                                            //     .length
                                            //     .toString(),
                                            ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.eye,
                                        color: Color(0xff262626),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                            style: TextStyle(
                                              color: Color(0xff262626),
                                              fontSize: 14,
                                            ),
                                            NumberFormat.compact()
                                                .format(likeData['views'])
                                            // likeData['views'].toString(),
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
                  likeData.isEmpty || likeData['comments'].isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'No any Comment yet',
                              style: TextStyle(
                                color: Color(0xff262626),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: likeData['comments'].length,
                          itemBuilder: (context, index) {
                            var timestamp =
                                likeData['comments'][index]['created_at'];
                            var convertedTimestamp =
                                DateTime.parse(timestamp).toLocal();
                            var result = GetTimeAgo.parse(convertedTimestamp);
                            return ListTile(
                              leading: likeData['comments'][index]
                                          ['client_profile']['image'] ==
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: likeData['comments']
                                                      [index]['client_profile']
                                                  ['gender'] ==
                                              "Male"
                                          ? AssetImage('assets/man.png')
                                          : AssetImage('assets/woman.png'),
                                      radius: 20,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          '${Api.baseUrl}${likeData['comments'][index]['client_profile']['image']}',
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 20,
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        color: Color(0xff0071e7),
                                      ),
                                    ),
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Text(
                                      likeData['comments'][index]
                                          ['client_profile']['username'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff262626),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    result,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff262626).withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                likeData['comments'][index]['content'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Manane',
                                  color: Color(0xff262626),
                                ),
                              ),
                            );
                          })
                ],
              ),
            ),
            //hapa ntwaweka bbotom
            _buildTextComposer(),
          ])),
    );
  }

  final FocusNode focus = FocusNode();
  Widget _buildTextComposer() {
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
              child: TextField(
                focusNode: focus,
                controller: _textController,
                onChanged: (String messageText) {
                  setState(() {
                    _isComposing = messageText.trim().isNotEmpty;
                  });
                },
                style: TextStyle(color: Color(0xff262626)),
                keyboardType: TextInputType.multiline,
                //expands: true,

                minLines: 1,
                maxLines: 3,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                    hintText: 'Leave a comment ',
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
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // Handle sending message logic here
    sendmsg(messageText);
  }

  void sendmsg(msg) async {
    var uid = context.read<ApiCalls>().currentUser;
    var m = {
      "post": widget.data['id'].toString(),
      "client": uid.toString(),
      "content": msg,
    };

    var response = await http.post(
      Uri.parse(
        '${Api.baseUrl}/create-comments/',
      ),
      body: m,
    );

    // print(response.statusCode);
    if (response.statusCode == 201) {
      final data = context.read<ApiCalls>();
      data.fetchMostViews();
      data.fetchMostLiked();
      getDetails();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
