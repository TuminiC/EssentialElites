import 'package:flutter/material.dart';

import '../services/speech_service.dart';
import '../services/watson_service.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  final List<ChatMessage> _message = [];
  final TextEditingController _textController = TextEditingController();
  // final SpeechService _speechService = SpeechService();
  final WatsonService _watsonService = WatsonService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    // _speechService.initSpeech();
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    _addMessage(text, true);
    String response = await _watsonService.getResponse(text);
    _addMessage(response, false);
    // _speechService.speak(response);
  }

  void _addMessage(String text, bool isUser) {

    ChatMessage message = ChatMessage(
      text: text,
      isUser: isUser,
      backgroundColor: isUser ? Colors.teal.shade200 : Colors.white,
      textColor: isUser ? Colors.black87 : Colors.black
    );

    setState(() {
      _message.insert(0, message);
    });
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    // _speechService.flutterTts.stop();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Support'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ),
        ), 
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _message[index],
                itemCount: _message.length,
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide.none
                ),
                hintText: 'Send a message'
                ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Colors.teal,
          ),
          // IconButton(
          //   icon: Icon(_speechService.isListening ? Icons.mic : Icons.mic_none),
          //   onPressed: () => _speechService.listen(_textController),
          // )
        ],
      ),
    );  
  }

  
}