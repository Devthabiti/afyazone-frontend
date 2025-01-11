import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

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
                'assets/p4.svg',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Your Privacy Matters',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff1684A7),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                  'We prioritize your privacy with top-notch security measures. Your personal health information is safe with us.',
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
