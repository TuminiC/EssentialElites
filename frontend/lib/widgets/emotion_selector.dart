import 'package:flutter/material.dart';

class EmotionSelector extends StatefulWidget {
  final Function(String) onEmotionSelected;

  EmotionSelector({required this.onEmotionSelected});

  @override
  _EmotionSelectorState createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  String? _selectedEmotion;

  final List<Map<String, dynamic>> emotions = [
    {'label': 'Happy', 'icon': Icons.sentiment_satisfied, 'color': Colors.yellow},
    {'label': 'Sad', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.blue},
    {'label': 'Anxious', 'icon': Icons.sentiment_neutral, 'color': Colors.orange},
    {'label': 'Calm', 'icon': Icons.self_improvement, 'color': Colors.green},
    // Add more emotions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: emotions.map((emotion) {
        bool isSelected = _selectedEmotion == emotion['label'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedEmotion = emotion['label'];
            });
            widget.onEmotionSelected(emotion['label']);
          },
          child: Chip(
            avatar: Icon(
              emotion['icon'],
              color: Colors.white,
            ),
            label: Text(
              emotion['label'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: isSelected ? emotion['color'] : Colors.grey,
            shape: StadiumBorder(),
          ),
        );
      }).toList(),
    );
  }
}