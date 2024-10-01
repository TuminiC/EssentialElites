import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/emotion_selector.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late WebSocketChannel channel;
  String selectedEmotion = '';
  String meditationText = '';
  bool isLoading = false;
  bool isSpeaking = false;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
    _initTts();
  }

  void _connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws_meditation'),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5); // Slower speech rate
    await flutterTts.setVolume(0.8);
    await flutterTts.setPitch(0.9); // Slightly lower pitch for a calmer voice

    var voices = await flutterTts.getVoices;
    print(voices);
    // var preferredVoice = voices.firstWhere(
    //   (voice) => voice.name.contains("female") && voice.name.contains("calm"),
    //   orElse: () => voices.first,
    // );
 await flutterTts.setVoice({"name": "Samantha", "locale": "en-US"});

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  void _requestMeditation() {
    setState(() {
      isLoading = true;
      meditationText = '';
    });
    channel.sink.add('{"emotion": "$selectedEmotion"}');
    channel.stream.listen((message) {
      if (message == '[EOS]') {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          meditationText += message;
        });
      }
    });
  }

  Future<void> _speak() async {
    if (!isSpeaking) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(meditationText);
    } else {
      setState(() {
        isSpeaking = false;
      });
      await flutterTts.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7CB9E8), Color(0xFF0077BE)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guided Meditation',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 10),
                EmotionSelector(
                  onEmotionSelected: (emotion) {
                    setState(() {
                      selectedEmotion = emotion;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: selectedEmotion.isNotEmpty ? _requestMeditation : null,
                  child: Text('Generate Meditation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0077BE),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : meditationText.isNotEmpty
                            ? Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        meditationText,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: _speak,
                                    icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
                                    label: Text(isSpeaking ? 'Stop' : 'Start Meditation'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0077BE),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Select an emotion and generate a meditation to begin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    flutterTts.stop();
    super.dispose();
  }
}