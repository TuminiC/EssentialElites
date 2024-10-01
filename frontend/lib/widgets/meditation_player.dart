import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MeditationPlayer extends StatefulWidget {
  final String meditationText;

  const MeditationPlayer({super.key, required this.meditationText});

  @override
  _MeditationPlayerState createState() => _MeditationPlayerState();
}

class _MeditationPlayerState extends State<MeditationPlayer> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _speak() async {
    if (widget.meditationText.isNotEmpty) {
      await flutterTts.speak(widget.meditationText);
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.meditationText,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        IconButton(
          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
          onPressed: isPlaying ? _stop : _speak,
          iconSize: 48,
          color: Color(0xFF4285F4),
        ),
      ],
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}