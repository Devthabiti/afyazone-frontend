import 'package:afya/models/services/login.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'first_page.dart';
import 'models/providers/token_provider.dart';

class SplashPage extends StatefulWidget {
  final String? token;
  const SplashPage({super.key, required this.token});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  final String _text = "AFYA NI MTAJI ";

  @override
  void initState() {
    super.initState();

    //fetch all api before run anything
    final data = context.read<ApiCalls>();
    data.fetchMostViews();
    // data.fetchUserDetails();
    // data.fetchDoctor();
    // data.fetchInbox();
    // data.fetcharticles();
    // data.fetchtransaction();
    // //data.fetchads();

    // context.read<ApiCalls>().userID();

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

  Widget mySplash() {
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
            child: Lottie.asset('assets/load-splash.json',
                height: 200, width: 200)),
        Positioned(
          bottom: 310,
          child: Text(
            _text.substring(0, _animation.value),
            style: const TextStyle(
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
    // print(widget.token);
    return AnimatedSplashScreen(
      splash: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/sp.jpeg'), fit: BoxFit.cover)),
          child: mySplash()),
      nextScreen: widget.token == null ? const LoginPage() : const FirstPage(),
      splashIconSize: MediaQuery.of(context).size.height,
      duration: 5000,
    );
  }
}
