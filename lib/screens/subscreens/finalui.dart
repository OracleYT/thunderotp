import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/shared/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalUI extends StatelessWidget {
  String number = '';
  FinalUI({Key key, this.controller, this.number}) : super(key: key);

  final ScrollController controller;
  List<String> appTips = [];
  int tipNo = 0;
  final _auth = FirebaseAuth.instance;

  int addTips() {
    appTips.add(
        "Don't be pushed around by the fears in your mind. Be led by the dreams in your heart.");
    appTips.add(
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine.");
    appTips.add(
        "“It’s only after you’ve stepped outside your comfort zone that you begin to change, grow, and transform.”");
    appTips.add(
        "“Success is not how high you have climbed, but how you make a positive difference to the world.”");
    appTips.add(
        "“Success is not how high you have climbed, but how you make a positive difference to the world.”");
    appTips
        .add("“Start each day with a positive thought and a grateful heart.”");
    return appTips.length;
  }

  @override
  Widget build(BuildContext context) {
    int tipsLength = addTips();
    var rng = new Random();
    tipNo = rng.nextInt(tipsLength);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
        ),
        Text(
          'LETS BEGIN.'.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: CustomColors.textGreen,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Text(
          'WELCOME',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: CustomColors.headerText,
            fontSize: 50,
            fontWeight: FontWeight.w800,
            height: .9,
          ),
        ),
        // SizedBox(
        //   height: 4,
        // ),
        // Text(
        //   "$number",
        //   textAlign: TextAlign.center,
        //   style: GoogleFonts.nunito(
        //     color: CustomColors.text,
        //     fontSize: 14,
        //     fontWeight: FontWeight.w500,
        //     height: 1.2,
        //   ),
        // ),
        SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 70,
          height: 5,
          child: Container(
            color: CustomColors.orange,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Text(
            appTips[tipNo],
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: CustomColors.text,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        FlatButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => HomeScreen(),
              ),
            );
            //Navigator.push(context);
          },
          child: Column(
            children: [
              Text(
                'Log Out',
                style: GoogleFonts.nunito(
                  color: CustomColors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: CustomColors.orange,
              )
            ],
          ),
        ),
        _buildExteriorInfoSection(),
      ],
    );
  }

  Widget _buildExteriorInfoSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[],
        ),
      ),
    );
  }
}
