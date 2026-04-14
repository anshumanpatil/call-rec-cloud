import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cll_upld/theme/theme.dart';
import 'package:cll_upld/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRoutes.home);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: primaryColor.withValues(alpha: 0.75),
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: fixPadding * 4.0),
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: size.height * 0.18,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
