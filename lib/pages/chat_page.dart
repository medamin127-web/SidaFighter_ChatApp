import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String email;
  final String gender;
  const ChatPage({super.key, required this.email, required this.gender});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<String?> fetchNicknameByEmail(String email) async {
    late Stream<List<Message>> messageStream;

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot userDocument = snapshot.docs[0];
      return userDocument['nickname'];
    }

    return null; // Return null if user with given email is not found
  }

  String? nickname;

  void fetchUserNickname() async {
    final String email = widget.email; // Receiver's email
    final String? fetchedNickname = await fetchNicknameByEmail(email);

    if (fetchedNickname != null) {
      setState(() {
        nickname = fetchedNickname;
      });
    }
  }

  late List<Message> messageList;
  @override
  void initState() {
    super.initState();
    messageList = [];
    fetchUserNickname();
    getMessageStream().listen((messages) {
      setState(() {
        messageList = messages;
      });
    });
    // Access other properties like displayName, photoURL, etc.
  }

  void addMessage(String text) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? uid = currentUser?.uid;
    // Logged in user email
    String? email = currentUser?.email;

    final String? fromEmail = email;
    final String toEmail = widget.email; // Provide the receiver's ID
    final String content = text;
    final DateTime timestamp = DateTime.now();
    FirebaseFirestore.instance.collection('messages').add({
      'Content': content,
      'EmailFrom': fromEmail,
      'EmailTo': toEmail,
      'Time': timestamp,
    }).then((value) {
      print('Message stored successfully');
    }).catchError((error) {
      // Error occurred while storing the message
    });
  }

  // to convert timestamp format

  Stream<List<Message>> getMessageStream() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? uid = currentUser?.uid;
    // Logged in user email
    String? email = currentUser?.email;

    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('Time', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot doc) {
            final data = doc.data();
            final String emailFrom = (data as dynamic)['EmailFrom'];
            final String emailTo = data['EmailTo'];
            Timestamp timestamp = data['Time'];
            DateTime dateTime = timestamp.toDate();
            String formattedDateTime = DateFormat('EEE HH:mm').format(dateTime);
            final bool isFromLoggedInUser =
                emailFrom == email && emailTo == widget.email;
            final bool isToLoggedInUser =
                emailFrom == widget.email && emailTo == email;
            if (isFromLoggedInUser || isToLoggedInUser) {
              return Message(
                content: (data as dynamic)['Content'],
                sender: emailFrom,
                receiver: emailTo,
                timestamp: formattedDateTime,
              );
            } else {
              return null;
            }
          })
          .where((message) => message != null)
          .toList()
          .cast<Message>()
          .reversed // Reverse the list to display the latest message at the bottom
          .toList();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nickname ?? 'Loading...',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.gender,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      final message = messageList[index];

                      return Container(
                        child: Row(
                          mainAxisAlignment: message.isSender
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (message.isSender)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  message.timestamp,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            BubbleSpecialThree(
                              text: message.content,
                              color: message.isSender
                                  ? Color.fromARGB(255, 243, 59, 27)
                                  : Color(0xFFE8E8EE),
                              tail: true,
                              isSender: message.isSender,
                              textStyle: TextStyle(
                                color: message.isSender
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            if (!message.isSender)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  message.timestamp,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MessageBar(
              onSend: (text) {
                addMessage(text);
              },
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* void sendMessage() {
    String content = messageController.text.trim();
    if (content.isNotEmpty) {
      Message message = Message('User 1', content);
      setState(() {
        messages.add(message);
        messageController.clear();
      });
    }
  }*/
}

class Message {
  final String content;
  final String sender;
  final String receiver;
  final String timestamp;

  Message({
    required this.content,
    required this.sender,
    required this.receiver,
    required this.timestamp,
  });

  bool get isSender => sender == FirebaseAuth.instance.currentUser?.email;
}
