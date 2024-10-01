import 'package:flutter/material.dart';

class EmotionSelector extends StatelessWidget {
  final Function(String) onEmotionSelected;

  EmotionSelector({required this.onEmotionSelected});

  final List<String> emotions = ['Anxious', 'Stressed', 'Sad', 'Angry', 'Happy', 'Calm'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: emotions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () => onEmotionSelected(emotions[index]),
              child: Text(emotions[index]),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF0077BE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}