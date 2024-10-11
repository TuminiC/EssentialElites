import 'package:flutter/material.dart';
import '../models/resource.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;

  ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resource.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
              ),
            ),
            SizedBox(height: 8),
            Chip(
              label: Text(
                resource.type,
                style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w500),
              ),
              backgroundColor: Color(0xFFE8EAFD),
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, resource.address),
            SizedBox(height: 4),
            _buildInfoRow(Icons.phone, resource.phone),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchPhone(resource.phone),
              icon: Icon(Icons.phone, color: Colors.white),
              label: Text('Call Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the error gracefully
      // ScaffoldMessenger.of(.).showSnackBar(
      //   SnackBar(content: Text('Could not launch phone dialer')),
      // );
    }
  }
}