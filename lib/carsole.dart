import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'models/providers/token_provider.dart';

class CarsolePge extends StatefulWidget {
  CarsolePge({Key? key}) : super(key: key);

  @override
  State<CarsolePge> createState() => _CarsolePgeState();
}

class _CarsolePgeState extends State<CarsolePge> {
  @override
  Widget build(BuildContext context) {
    var imgList = context.watch<ApiCalls>().matangazo;
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        CachedNetworkImage(
                          imageUrl: item['image'],
                          imageBuilder: (context, imageProvider) => Container(
                              // width: MediaQuery.of(context).size.width,
                              width: double.infinity,
                              // height: MediaQuery.of(context).size.height * 0.2,
                              // height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover))),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: ListTile(
                              title: Container(
                                width: 250.0,
                                height: 20.0,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                width: 170.0,
                                height: 86.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Color.fromARGB(100, 0, 0, 0),
                                //     Color.fromARGB(0, 0, 0, 0)
                                //   ],
                                //   begin: Alignment.bottomCenter,
                                //   end: Alignment.topCenter,
                                // ),
                                ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return imgList.isEmpty
        ? Container(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: ListTile(
                title: Container(
                  width: 250.0,
                  height: 20.0,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: 170.0,
                  height: 86.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            //margin: EdgeInsets.all(20),
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2.3,
                viewportFraction: 1,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                autoPlay: true,
              ),
              items: imageSliders,
            ),
          );
  }
}
