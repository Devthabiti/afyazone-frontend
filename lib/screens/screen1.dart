import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

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
                'assets/p1.svg',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Book Appointments',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff1684A7),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                  'Schedule your consultations with just a few taps. Choose your preferred time and get reminders for upcoming appointments.',
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
