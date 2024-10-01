import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widgets/chat_bubble.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import 'resources_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late WebSocketChannel channel;
  String _currentAIResponse = '';
  bool _isReceivingResponse = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _addAIResponse(String response) {
  setState(() {
    if (_messages.isNotEmpty && !_messages.last.isUser) {
      _messages.last = Message(text: _messages.last.text + response, isUser: false);
    } else {
      _messages.add(Message(text: response, isUser: false));
    }
  });
  _scrollToBottom();
}

  void _connectWebSocket() {
  channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:8000/ws'),
  );

  channel.stream.listen((message) {
    if (message == '[EOS]') {
      // End of stream, do nothing
    } else {
      _updateAIResponse(message);
    }
  });
}

void _updateAIResponse(String message) {
    setState(() {
      _isReceivingResponse = true;
      _currentAIResponse += message;
      if (_messages.isNotEmpty && !_messages.last.isUser) {
        _messages.last = Message(text: _currentAIResponse, isUser: false);
      } else {
        _messages.add(Message(text: _currentAIResponse, isUser: false));
      }
    });
    _scrollToBottom();
  }

  void _finishAIResponse() {
    setState(() {
      _isReceivingResponse = false;
      _currentAIResponse = '';
    });
  }


  // void _sendMessage(String message) {
  //   if (message.isNotEmpty) {
  //     _addMessage(Message(text: message, isUser: true));
  //     channel.sink.add('{"message": "$message"}');
  //     _textController.clear();
  //   }
  // }
  void _sendMessage(String message) {
  if (message.isNotEmpty) {
    setState(() {
      _currentAIResponse = '';
      _isReceivingResponse = false;
      _messages.add(Message(text: message, isUser: true));
    });
    channel.sink.add('{"message": "$message"}');
    _textController.clear();
    _scrollToBottom();
    }
  }


  void _addMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text('AI Therapist Chat', style: TextStyle(color: Color(0xFF4285F4))),
        backgroundColor: Colors.white,
        elevation: 0,  
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                }    
              ),
          ),
          _buildMessageComposer(),
        ] 
      ),
    
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF4285F4),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
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

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFF0F4FF),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4285F4),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

}

// class ChatBubble extends StatelessWidget {
//   final Message message;

//   ChatBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: message.isUser ? Color(0xFF4285F4) : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           message.text,
//           style: TextStyle(
//             color: message.isUser ? Colors.white : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }