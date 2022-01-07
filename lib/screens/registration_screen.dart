import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}
String otp = '';
String number = '';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
        //Navigator.pushNamed(context, Home(number).id);
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Home(number),
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

  registernumberWidget(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Row(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: 70.0,
                ),
              ),
              TypewriterAnimatedTextKit(
                text: ['Global Free'],
                textStyle: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: const Duration(milliseconds: 180),
              ),
            ],
          ),
          SizedBox(
            height: 75,
          ),
          Text(
            'Registration',
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
            "Add your phone number. we'll send you a verification code so we know you're real",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 28,
          ),
          Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Color.fromRGBO(240, 252, 255, 1),
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
                      color: Colors.blueAccent,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showLoading = true;
                      });

                      await _auth.verifyPhoneNumber(
                        phoneNumber: '+91' + phoneController.text,
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(() {
                            number = '+91' + phoneController.text;
                            showLoading = false;
                          });
                          //signInWithPhoneAuthCredential(phoneAuthCredential);
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
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Terms and Conditions Applied!",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  otpWidget(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: 70.0,
                ),
              ),
              TypewriterAnimatedTextKit(
                text: ['Global Free'],
                textStyle: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: const Duration(milliseconds: 180),
              ),
            ],
          ),
          SizedBox(
            height: 75,
          ),
          Text(
            'Verification',
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
            "Enter your OTP code number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 28,
          ),
          Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Color.fromRGBO(240, 252, 255, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textFieldOTP(first: true, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: true),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(otp);
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: otp);

                      signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Verify',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
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
              color: Colors.lightBlueAccent.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
        child: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? registernumberWidget(context)
                : otpWidget(context),
      ),
    );
  }

  Widget _textFieldOTP({bool first, last}) {
    return Container(
      height: 65,
      width: 40,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            otp = otp + value;

            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}


// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flash_chat/components/Rounded_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'chat_screen.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

// class RegistrationScreen extends StatefulWidget {
//   static const String id = 'registration_screen';
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _auth = FirebaseAuth.instance;
//   String email;
//   bool showspiner = false;
//   String password;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: ModalProgressHUD(
//         inAsyncCall: showspiner,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               SizedBox(
//                 height: 50,
//               ),
//               Row(
//                 children: <Widget>[
//                   Hero(
//                     tag: 'logo',
//                     child: Container(
//                       child: Image.asset('images/logo.png'),
//                       height: 70.0,
//                     ),
//                   ),
//                   TypewriterAnimatedTextKit(
//                     text: ['Global Free'],
//                     textStyle: TextStyle(
//                       fontSize: 45.0,
//                       fontWeight: FontWeight.w900,
//                     ),
//                     speed: const Duration(milliseconds: 180),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 75,
//               ),
//               Text(
//                 'Registration',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Add your phone number. we'll send you a verification code so we know you're real",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black38,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 28,
//               ),
//               Container(
//                 padding: EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(240, 252, 255, 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       keyboardType: TextInputType.number,
//                       maxLength: 10,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black12),
//                             borderRadius: BorderRadius.circular(10)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black12),
//                             borderRadius: BorderRadius.circular(10)),
//                         prefix: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8),
//                           child: Text(
//                             '(+91)',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         suffixIcon: Icon(
//                           Icons.check_circle,
//                           color: Colors.blueAccent,
//                           size: 32,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 22,
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           setState(() {
//                             showspiner = true;
//                           });
//                           try {
//                             final newUser =
//                                 await _auth.createUserWithEmailAndPassword(
//                                     email: email, password: password);
//                             if (newUser != null) {
//                               Navigator.pushNamed(context, ChatScreen.id);
//                             }
//                             setState(() {
//                               showspiner = false;
//                             });
//                           } catch (e) {
//                             print(e);
//                           }
//                         },
//                         style: ButtonStyle(
//                           foregroundColor:
//                               MaterialStateProperty.all<Color>(Colors.white),
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               Colors.lightBlueAccent),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(14.0),
//                           child: Text(
//                             'Send',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Terms and Conditions Applied!",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.lightBlueAccent.withOpacity(0.8),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 40,
//               )
//               // Flexible (
//               //   child: Hero(
//               //     tag: 'logo',
//               //     child: Container(
//               //       height: 200.0,
//               //       child: Image.asset('images/logo.png'),
//               //     ),
//               //   ),
//               // ),
//               // SizedBox(
//               //   height: 48.0,
//               // ),
//               // TextField(
//               //   keyboardType: TextInputType.emailAddress,
//               //   textAlign: TextAlign.center,
//               //   onChanged: (value) {
//               //     email = value;
//               //   },
//               //   decoration: InputDecoration(
//               //     hintText: 'Enter your email',
//               //     contentPadding:
//               //         EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               //     border: OutlineInputBorder(
//               //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               //     ),
//               //     enabledBorder: OutlineInputBorder(
//               //       borderSide:
//               //           BorderSide(color: Colors.blueAccent, width: 1.0),
//               //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               //     ),
//               //     focusedBorder: OutlineInputBorder(
//               //       borderSide:
//               //           BorderSide(color: Colors.blueAccent, width: 2.0),
//               //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               //     ),
//               //   ),
//               // ),
//               // SizedBox(
//               //   height: 8.0,
//               // ),
//               // TextField(
//               //   textAlign: TextAlign.center,
//               //   obscureText: true,
//               //   onChanged: (value) {
//               //     password = value;
//               //   },
//               //   decoration: InputDecoration(
//               //     hintText: 'Enter your password',
//               //     contentPadding:
//               //         EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               //     border: OutlineInputBorder(
//               //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               //     ),
//               //     enabledBorder: OutlineInputBorder(
//               //       borderSide:
//               //           BorderSide(color: Colors.blueAccent, width: 1.0),
//               //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               //     ),
//               //     focusedBorder: OutlineInputBorder(
//               //       borderSide:
//               //           BorderSide(color: Colors.blueAccent, width: 2.0),
//               //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               //     ),
//               //   ),
//               // ),
//               // SizedBox(
//               //   height: 24.0,
//               // ),
//               // RoundedButton(
//               //   onPressed: () async {
//               //     setState(() {
//               //       showspiner = true;
//               //     });
//               //     try {
//               //       final newUser = await _auth.createUserWithEmailAndPassword(
//               //           email: email, password: password);
//               //       if (newUser != null) {
//               //         Navigator.pushNamed(context, ChatScreen.id);
//               //       }
//               //       setState(() {
//               //         showspiner = false;
//               //       });
//               //     } catch (e) {
//               //       print(e);
//               //     }
//               //   },
//               //   title: 'Register',
//               //   color: Colors.blueAccent,
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
