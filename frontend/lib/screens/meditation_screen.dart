import 'package:flutter/material.dart';
import 'package:mental_crisis_app/screens/resources_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _showMeditationText = false;
  bool _isMusicPlaying = true;
  bool _isMeditationActive = false;

  FlutterTts flutterTts = FlutterTts();
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
    _initTts();
    _initAudioPlayer();
  }

  void _connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws_meditation'),
    );
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.3); // Slower speech rate
    await flutterTts.setVolume(0.6); // Lower volume for a softer voice
    await flutterTts.setPitch(0.5); // Lower pitch for a more calming effect

    var voices = await flutterTts.getVoices;
    print(voices);

    // Select a more soothing voice if available
    var preferredVoice = voices.firstWhere(
      (voice) => voice.name.toLowerCase().contains("samantha"),
      orElse: () => voices.first,
    );
    await flutterTts.setVoice({"name": preferredVoice.name, "locale": "en-US"});

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        _isMeditationActive = false;
      });
    });
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioPlayer!.setReleaseMode(ReleaseMode.loop);
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _audioPlayer!.play(AssetSource('assets/audio/soft_background.mp3'));
  }

  Future<void> _stopBackgroundMusic() async {
    await _audioPlayer!.stop();
  }

  void _requestMeditation() {
    setState(() {
      isLoading = true;
      meditationText = '';
      _showMeditationText = false;
      _isMeditationActive = false;
    });
    channel.sink.add('{"emotion": "$selectedEmotion"}');
    channel.stream.listen((message) {
      if (message == '[EOS]') {
        setState(() {
          isLoading = false;
          _showMeditationText = true;
        });
      } else if (message.startsWith("Error:")) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Failed to generate meditation. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        setState(() {
          meditationText += message;
        });
      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "An unexpected error occurred.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  Future<void> _speak() async {
    if (!isSpeaking) {
      setState(() {
        isSpeaking = true;
        _isMeditationActive = true;
      });
      await flutterTts.speak(meditationText);
    } else {
      setState(() {
        isSpeaking = false;
        _isMeditationActive = false;
      });
      await flutterTts.stop();
    }
  }

  Widget _buildMeditationContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)));
    } else if (meditationText.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedOpacity(
                opacity: _showMeditationText ? 1.0 : 0.0,
                duration: Duration(seconds: 2),
                child: Text(
                  meditationText,
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _isMeditationActive
              ? LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0077BE)),
                )
              : SizedBox.shrink(),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _speak,
            icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
            label: Text(isSpeaking ? 'Stop Meditation' : 'Start Meditation'),
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
      );
    } else {
      return Center(
        child: Text(
          'Select an emotion and generate a meditation to begin',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      );
    }
  }

  Widget _buildEmotionSelector() {
    return EmotionSelector(
      onEmotionSelected: (emotion) {
        setState(() {
          selectedEmotion = emotion;
        });
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    flutterTts.stop();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Updated gradient to more soothing colors
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/meditation_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: 'Guided Meditation Title',
                  child: Text(
                    'Guided Meditation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Semantics(
                  label: 'Emotion Selection Prompt',
                  child: Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                _buildEmotionSelector(),
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
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : meditationText.isNotEmpty
                            ? Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: AnimatedOpacity(
                                        opacity: _showMeditationText ? 1.0 : 0.0,
                                        duration: Duration(seconds: 2),
                                        child: Text(
                                          meditationText,
                                          style: TextStyle(fontSize: 18, color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _isMeditationActive
                                      ? LinearProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0077BE)),
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: _speak,
                                    icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
                                    label: Text(isSpeaking ? 'Stop Meditation' : 'Start Meditation'),
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
                                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Color(0xFFFF6584),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ResourcesScreen()),
            );
          } else if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Resources'),
        ],
      ),
    );
  }
}