import 'package:flash_chat/screens/final_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/shared/colors.dart';
import 'package:flash_chat/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}
String otp = '';
String number = '';

class BenefitsSubscreen extends StatefulWidget {
  BenefitsSubscreen({
    Key key,
    this.controller,
  }) : super(key: key);

  final ScrollController controller;

  @override
  State<BenefitsSubscreen> createState() => _BenefitsSubscreenState();
}

class _BenefitsSubscreenState extends State<BenefitsSubscreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();

  final otpController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String email;

  bool showspiner = false;

  String password;

  String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Finalscreen(number),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  // REGISTER NUMBER PART

  registeration(context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 200.0,
          ),
          Text(
            'Are you ready'.toUpperCase(),
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
            'Register',
            style: GoogleFonts.poppins(
              color: CustomColors.headerText,
              fontSize: 50,
              fontWeight: FontWeight.w800,
              height: .9,
            ),
          ),
          SizedBox(
            height: 28,
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
          Text(
            "Add your phone number.\nwe'll send you a verification code\n so we know you're real.",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: CustomColors.text,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          SizedBox(
            height: 28,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '(+91)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: CustomColors.textGreen,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  CustomButton(
                    text: 'Send',
                    minWidth: 200,

                    onPressed: () async {
                      await _auth.verifyPhoneNumber(
                        phoneNumber: '+91' + phoneController.text,
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(() {
                            number = '+91' + phoneController.text;
                            showLoading = false;
                          });
                          signInWithPhoneAuthCredential(phoneAuthCredential);
                        },
                        verificationFailed: (verificationFailed) async {
                          setState(() {
                            number = '+91' + phoneController.text;
                            showLoading = false;
                          });
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(verificationFailed.message)));
                        },
                        codeSent: (verificationId, resendingToken) async {
                          setState(() {
                            number = '+91' + phoneController.text;
                            showLoading = false;
                            currentState =
                                MobileVerificationState.SHOW_OTP_FORM_STATE;
                            this.verificationId = verificationId;
                          });
                        },
                        codeAutoRetrievalTimeout: (verificationId) async {},
                      );
                      number = '+91' + phoneController.text;
                      phoneController.clear();
                    },
                    // onPressed: () {
                    //   widget.controller.animateTo(0,
                    //       duration: Duration(milliseconds: 2300),
                    //       curve: Curves.ease);
                    // },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }

  // VERIFY OTP PART.

  verification(context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 200.0,
          ),
          Text(
            'IS IT YOU?'.toUpperCase(),
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
            'Verify',
            style: GoogleFonts.poppins(
              color: CustomColors.headerText,
              fontSize: 50,
              fontWeight: FontWeight.w800,
              height: .9,
            ),
          ),
          SizedBox(
            height: 28,
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
          Text(
            "Enter your OTP code number.",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: CustomColors.text,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          SizedBox(
            height: 28,
          ),
          Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    // maxLength: 10,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      // hintText: 'OTP',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                CustomButton(
                  text: 'Verify',
                  minWidth: 200,
                  onPressed: () async {
                    print(otp);
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: phoneController.text);

                    signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            "Didn't you receive any code?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            "Resend New Code",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CustomColors.textGreen,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }

  //KEY

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TOGGLE THE UI AS PER THE REQUIREMENT.
    return currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
        ? registeration(context)
        : verification(context);
  }
}
