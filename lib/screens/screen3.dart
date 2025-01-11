import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

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
                'assets/p2.svg',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Personalized Health Insights',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff1684A7),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                  'Receive tailored health tips and recommendations based on your health profile and consultation history.',
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
