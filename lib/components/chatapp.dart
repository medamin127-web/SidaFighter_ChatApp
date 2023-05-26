import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  final List<Conversation> conversations = [
    Conversation('John Doe', 'Hey, how are you?', DateTime.now()),
    Conversation('Jane Smith', "Hi, I'm good!", DateTime.now()),
    // Add more conversation data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(conversation.name[0]),
            ),
            title: Text(
              conversation.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(conversation.message),
            trailing: Text(
              conversation.time.toString(),
              style: TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}

class Conversation {
  final String name;
  final String message;
  final DateTime time;

  Conversation(this.name, this.message, this.time);
}
