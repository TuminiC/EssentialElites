// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'screens/chat_screen.dart';


// void main() {
//   FlutterError.onError = (FlutterErrorDetails details) {
//     FlutterError.presentError(details);
//     debugPrint(details.toString());
//   };
//   runApp(MentalHealthApp());
// }

// class MentalHealthApp extends StatelessWidget {

//   Widget build(BuildContext context){
//     debugPrint("Mental Health App is running");
//     return MaterialApp(
//       title: 'Mental Health Support',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         textTheme: GoogleFonts.(
//           Theme.of(context).textTheme
//         )
//       ),
//       home: ChatScreen()
//       );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Support',
      theme: ThemeData(
        primaryColor: Color(0xFF3F51B5), // Indigo
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light grey background
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF3F51B5), // Indigo
          secondary: Color(0xFF00BCD4), // Cyan
          background: Color(0xFFF5F5F5), // Light grey
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onSurface: Colors.black,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Color(0xFF333333), // Dark grey for body text
          displayColor: Color(0xFF3F51B5), // Indigo for headings
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00BCD4), // Cyan
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF3F51B5), // Indigo
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}