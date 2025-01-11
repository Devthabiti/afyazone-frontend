import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/providers/token_provider.dart';
import 'doctor_news_details.dart';

class DoctorSearchPage extends StatefulWidget {
  @override
  _DoctorSearchState createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearchPage> {
  List articles = [];
  void searchArticles(String query) {
    var art = context.read<ApiCalls>().articles;
    // var art = story.where((element) => element['category'] == 'story').toList();
    final sug = art.where((article) {
      var tittle = article['title'].toLowerCase();
      var content = article['content'].toLowerCase();
      var category = article['category'].toLowerCase();
      var input = query.toLowerCase();
      return tittle.contains(input) ||
          content.contains(input) ||
          category.contains(input);
    }).toList();
    setState(() {
      articles = sug;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: const Color(0xff09A599),
      title: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: "Search Articles",
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        onChanged: searchArticles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildSearchField(),
        body: articles.isEmpty
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 6,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => ListTile(
                          leading: Container(
                            width: 70.0,
                            height: 56.0,
                            color: Colors.white,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 250.0,
                                height: 20.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 200.0,
                                height: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          subtitle: Container(
                            width: 170.0,
                            height: 86.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
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
                        leading: CachedNetworkImage(
                          imageUrl: '${articles[index]['image']}',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(backgroundImage: imageProvider),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                        ),
                        title: Text(
                          articles[index]['title'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff314165)),
                        ),
                        trailing: Text(
                          '${articles[index]['views']} Views',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff314165),
                          ),
                        ),
                      ),
                      Divider(
                        indent: 60,
                      )
                    ],
                  );
                },
              ));
  }
}
