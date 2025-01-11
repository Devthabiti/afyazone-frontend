import 'package:afya/screens/screen1.dart';
import 'package:afya/screens/screen2.dart';
import 'package:afya/screens/screen3.dart';
import 'package:afya/screens/screen4.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'models/services/login.dart';

class OnboaridngScreen extends StatefulWidget {
  const OnboaridngScreen({super.key});

  @override
  State<OnboaridngScreen> createState() => _OnboaridngScreenState();
}

class _OnboaridngScreenState extends State<OnboaridngScreen> {
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: const [
              Screen1(),
              Screen2(),
              Screen3(),
              Screen4(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.50),
            child: SmoothPageIndicator(
              controller: controller,
              count: 4,
              effect: const WormEffect(
                  //dotColor: Colors.amber,
                  activeDotColor: Color(0xff1684A7),
                  dotHeight: 12,
                  dotWidth: 12),
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Container(
                    height: 45,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xff1684A7), Color(0xff09A599)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp, // This is the default
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                            fontFamily: 'Manane',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
