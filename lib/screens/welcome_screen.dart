import 'dart:developer';
import 'package:flash_chat/components/Rounded_button.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blue[200], end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 240.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),

            SizedBox(
              height: 100,
            ),
            Text(
              "Let's get started",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Never a better time than now to start.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            // SizedBox(
            //   height: 48.0,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundedButton(
                title: 'Create Account',
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundedButton(
                title: 'Log in',
                color: Colors.lightBlueAccent,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
