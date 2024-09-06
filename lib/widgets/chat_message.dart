import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color backgroundColor;
  final Color textColor;

  ChatMessage({
    Key? key,
    required this.text, 
    required this.isUser,
    required this.backgroundColor,
    required this.textColor,
    }) : super(key: Key(text));


  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(!isUser)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text('AI'), backgroundColor: Colors.teal,),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: 
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(isUser ? 'You' : 'Mental Health Assistant', style: TextStyle(fontWeight: FontWeight.bold),),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(text, style: TextStyle(color: textColor),),
                )
              ],
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(child: Text('You'), backgroundColor: Colors.teal.shade300,),
            ),
        ],
      ),

    );
  }
}