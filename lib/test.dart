import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  final String _text = "AFYA NI MTAJI ";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _text.length * 200), // Adjust speed here
      vsync: this,
    )..repeat(reverse: false);

    _animation = StepTween(
      begin: 0,
      end: _text.length,
    ).animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget showphone() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/afyazone-logo.png',
          height: 250,
          width: double.infinity,
        ),
        Positioned(
            bottom: 0,
            //top: 0,
            child: Lottie.asset('assets/load-splash.json',
                height: 200, width: 200)),
        Positioned(
          bottom: 310,
          child: Text(
            _text.substring(0, _animation.value),
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('dara')),
      // body: Center(
      //     child: Container(
      //         decoration: BoxDecoration(
      //             image: DecorationImage(
      //                 image: AssetImage('assets/sp.jpeg'), fit: BoxFit.cover)),
      //         height: MediaQuery.of(context).size.height,
      //         child: showphone())),
    );
  }
}
