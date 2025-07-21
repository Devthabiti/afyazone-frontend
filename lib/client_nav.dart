import 'package:afya/pages/chat.dart';
import 'package:afya/pages/doctors.dart';
import 'package:afya/pages/home.dart';
import 'package:afya/pages/news.dart';
import 'package:afya/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'models/providers/token_provider.dart';

class ClientNav extends StatefulWidget {
  const ClientNav({Key? key}) : super(key: key);

  @override
  State<ClientNav> createState() => _ClientNavState();
}

class _ClientNavState extends State<ClientNav> {
  late PageController pageController;
  int pageIndex = 0;

  //nafikiri hapa ndo ntacall api zote before sijaingia ndani
  // na api niziweke kwenye context yaan providers
  @override
  void initState() {
    final data = context.read<ApiCalls>();
    data.fetchUserDetails();
    // data.fetchDoctor();
    // data.fetchInbox();
    // data.fetcharticles();
    // data.fetchtransaction();
    // //data.fetchads();

    // context.read<ApiCalls>().userID();
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<ApiCalls>().clientData;
    return data.isEmpty //apa ntaweka & condition kufetch data zote
        ? Scaffold(
            body: SafeArea(
              child: Shimmer.fromColors(
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
                  )),
            ),
          )
        : Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                HomePage(),
                NewsPage(),
                ChatPage(),
                DoctorsPage(),
                Setting()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: pageIndex,
                onTap: onTap,
                fixedColor: const Color(0xff0071e7),
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: const Color(0xff262626),
                backgroundColor: const Color(0xffffffff),
                elevation: 10,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        Iconsax.home1,
                      ),
                      icon: Icon(
                        Iconsax.home,
                      )),
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        FontAwesomeIcons.fireFlameCurved,
                        size: 22,
                      ),
                      icon: Icon(
                        FontAwesomeIcons.fire,
                        size: 22,
                      )),
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        Iconsax.message1,
                      ),
                      icon: Icon(
                        Iconsax.message_favorite,
                      )),
                  BottomNavigationBarItem(
                    label: '',
                    activeIcon: Icon(
                      FontAwesomeIcons.userDoctor,
                      size: 22,
                    ),
                    icon: Icon(
                      FontAwesomeIcons.userDoctor,
                      size: 22,
                    ),
                  ),
                  BottomNavigationBarItem(
                      label: '',
                      activeIcon: Icon(
                        Iconsax.setting1,
                      ),
                      icon: Icon(
                        Iconsax.setting,
                        // size: 20,
                      )),
                ]),
          );
  }
}
