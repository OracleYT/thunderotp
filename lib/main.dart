import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/services.dart';
import 'package:flash_chat/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Parallax Scroll',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     runApp(FlashChat());
//   });
// }



// class FlashChat extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: WelcomeScreen.id,
//       routes: {
//         WelcomeScreen.id: (context) => WelcomeScreen(),
//         RegistrationScreen.id: (context) => RegistrationScreen(),
//         ChatScreen.id: (context) => ChatScreen(),
//       },
//     );
//   }
// }
