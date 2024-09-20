import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'resources_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text('MindfulChat', style: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   IconButton(icon: Icon(Icons.nightlight_round, color: Colors.black), onPressed: () {}),
        //   IconButton(icon: Icon(Icons.person_outline, color: Colors.black), onPressed: () {}),
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to MindfulChat',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your personal mental health companion',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              _buildCard(
                icon: Icons.chat_bubble_outline,
                title: 'Chat with AI Therapist',
                subtitle: 'Get support and guidance anytime, anywhere',
                buttonText: 'Start Chat',
                buttonColor: Color(0xFF4285F4),
                iconColor: Color(0xFF4285F4),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                ),
              ),
              SizedBox(height: 20),
              _buildCard(
                icon: Icons.location_on_outlined,
                title: 'Find Local Resources',
                subtitle: 'Discover mental health services near you',
                buttonText: 'Explore Resources',
                buttonColor: Color(0xFF9C27B0),
                iconColor: Color(0xFF9C27B0),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResourcesScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required Color iconColor,
    required VoidCallback onPressed,

    

  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: iconColor),
            SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}