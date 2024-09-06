import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';


void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  runApp(MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {

  Widget build(BuildContext context){
    debugPrint("Mental Health App is running");
    return MaterialApp(
      title: 'Mental Health Support',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: ChatScreen()
      );
  }
}

