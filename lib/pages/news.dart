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
import '../news/search_news.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Widget search() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ));
        },
        child: Container(
          width: 300,
          height: 40,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2) //Color(0xff262626),
              ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Icon(Icons.search, color: Color(0xff262626).withOpacity(0.5)),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff262626).withOpacity(0.5)),
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
    var uid = context.watch<ApiCalls>().currentUser;
    var articles = context.watch<ApiCalls>().articles;

    return Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(
            toolbarHeight: 80,
            elevation: 1,
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: const Color(0xffFFFFFF),
            title: search()),
        body: articles.isEmpty
            ? Center(
                child: Lottie.asset(
                  'assets/loader.json',
                  width: 100,
                  height: 100,
                ),
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
                                  builder: (context) => NewsDetails(
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
                              padding: const EdgeInsets.only(top: 2),
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
                          style:
                              TextStyle(color: Color(0xff262626), fontSize: 12),
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
                                  builder: (context) => NewsDetails(
                                        data: articles[index],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, bottom: 10),
                          child: Text(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            '${articles[index]['title']} ${articles[index]['content']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Tahoma',
                              color: Color(0xff262626),
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
                            placeholder: (context, url) => Lottie.asset(
                              'assets/loader.json',
                              width: 100,
                              height: 100,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              likes.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        postData(articles[index]['id'], uid);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 40,
                                        // color: Colors.amber,
                                        child: Lottie.asset('assets/heart.json',
                                            repeat: false, fit: BoxFit.cover),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(left: 5),
                                      height: 50,
                                      width: 40,
                                      // color: Colors.amber,
                                      child: IconButton(
                                        onPressed: () {
                                          postData(articles[index]['id'], uid);
                                        },
                                        icon: Icon(
                                          Iconsax.heart,
                                          color: Color(0xff262626),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Text(
                                  style: TextStyle(
                                    color: Color(0xff262626),
                                    fontSize: 14,
                                  ),
                                  articles[index]['likes'].toString(),
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              final data = context.read<ApiCalls>();
                              data.fetchview(articles[index]['id'].toString());
                              data.fetcharticles();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetails(
                                            data: articles[index],
                                          )));
                            },
                            child: Row(
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
                                    articles[index]['comments']
                                        .length
                                        .toString(),
                                  ),
                                )
                              ],
                            ),
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
