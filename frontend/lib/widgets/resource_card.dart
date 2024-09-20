import 'package:flutter/material.dart';
import '../models/resource.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;

  ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resource.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
            SizedBox(height: 8),
            Text(resource.address, style: TextStyle(color: Colors.black87)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(resource.hours, style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(resource.phone, style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8EAFD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    resource.category,
                    style: TextStyle(color: Color(0xFF4285F4)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.launch, size: 16),
                  label: Text('Visit Website'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}