import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meditation_screen.dart';
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
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              'Welcome to MindfulChat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your personal mental health companion',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            _buildCard(
              icon: Icons.self_improvement,
              title: 'Guided Meditation',
              subtitle: 'Relax and calm your mind',
              buttonText: 'Start Meditation',
              buttonColor: Color(0xFF34A853),
              iconColor: Color(0xFF34A853),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MeditationScreen()),
              ),
            ),
          ],
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: iconColor),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}