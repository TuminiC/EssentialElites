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
      elevation: 2,
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
                color: Color(0xFF4285F4),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFE8EAFD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resource.type,
                style: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.w500),
              ),
            ),
            // SizedBox(height: 12),
            // Text(
            //   resource.description,
            //   style: TextStyle(fontSize: 14, color: Colors.black87),
            // ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, resource.address),
            SizedBox(height: 4),
            _buildInfoRow(Icons.phone, resource.phone),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchPhone(resource.phone),
              child: Text('Call Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4285F4),
                foregroundColor: Colors.white,
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
      print('Could not launch $url');
    }
  }
}