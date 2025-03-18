import 'dart:convert';

import 'package:afya/news/news_details.dart';
import 'package:afya/news/news_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/providers/token_provider.dart';
import '../models/services/utls.dart';
import 'doctor_news_details.dart';
import 'doctor_search.dart';

class NewsDoctor extends StatefulWidget {
  const NewsDoctor({super.key});

  @override
  State<NewsDoctor> createState() => _NewsDoctorState();
}

class _NewsDoctorState extends State<NewsDoctor> {
  Widget search() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorSearchPage(),
              ));
        },
        child: Container(
          width: 300,
          height: 40,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 10),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Color(0xff09A599),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Search Articles',
                    style: TextStyle(fontSize: 16, color: Color(0xff314165)),
                  ),
                ),
              ],
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
        ));
  }

  // Fetch otp api **************************

  void postData(postId, clientId) async {
    var url = Uri.parse(' ${Api.baseUrl}/likes/');

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
      data.fetcharticles();
    }
  }

  void initState() {
    final data = context.read<ApiCalls>();

    data.fetcharticles();
    super.initState();
  }

  bool isLike = false;
  @override
  Widget build(BuildContext context) {
    var articles = context.watch<ApiCalls>().articles;
    var uid = context.watch<ApiCalls>().currentUser;
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: const Color(0xff09A599),
            elevation: 1,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: search()),
        body: articles.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  var timestamp = articles[index]['created_at'];
                  var convertedTimestamp = DateTime.parse(timestamp).toLocal();
                  var result = GetTimeAgo.parse(convertedTimestamp);

                  //filter likes
                  List lk = articles[index]['postlikes'];
                  List likes = lk
                      .where((element) => element['client'] == int.parse(uid))
                      .toList();

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          final data = context.read<ApiCalls>();
                          data.fetchview(articles[index]['id'].toString());
                          data.fetcharticles();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorNewsDetails(
                                        data: articles[index],
                                      )));
                        },
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/logo.jpg'),
                        ),
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text('Afyazone'),
                            ),
                            Icon(
                              Iconsax.verify5,
                              size: 20,
                              color: const Color(0xff1684A7),
                            ),
                          ],
                        ),
                        //subtitle: Divider(),
                        trailing: Text(
                          result,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final data = context.read<ApiCalls>();
                          data.fetchview(articles[index]['id'].toString());
                          data.fetcharticles();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorNewsDetails(
                                        data: articles[index],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, bottom: 10),
                          child: Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            articles[index]['content'].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Tahoma',
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsImageViewPage(
                                        imageUrl: articles[index]['image'])));
                          },
                          child: CachedNetworkImage(
                            imageUrl: '${articles[index]['image']}',
                            imageBuilder: (context, imageProvider) => Container(
                              child: Image(image: imageProvider),
                              // decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //         image: imageProvider, fit: BoxFit.cover)),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
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
                                  articles[index]['likes'].toString(),
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
                                  articles[index]['comments'].length.toString(),
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
                                  articles[index]['views'].toString(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Divider(
                          thickness: 1,
                        ),
                      )
                    ],
                  );
                },
              ));
  }
}
