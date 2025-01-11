import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              margin: const EdgeInsets.all(15),
              width: double.infinity,
              //color: Colors.amber,
              child: SvgPicture.asset(
                'assets/p5.svg',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Discover Top Doctors',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff1684A7),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                  'Browse through a list of qualified healthcare professionals. Find the right doctor for your needs based on specialties, ratings, and availability.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff314165),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
