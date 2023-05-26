import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/NewMessagePage.dart';
import 'package:flutter_application_1/pages/chat_page.dart';
import 'package:intl/intl.dart';

import '../components/MotivationalQuoteGenerator.dart';
import '../components/navbar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final user = FirebaseAuth.instance.currentUser!;

  String username = 'John Doe';

  String quote = MotivationalQuoteGenerator.getRandomQuote();

  final List<Conversation> conversations = [
    Conversation('John Doe', 'Hey, how are you?', DateTime.now(),
        'lib/images/anonymous.jpg'),
    Conversation('Jane Smith', "Hi, I'm good!", DateTime.now(),
        'lib/images/anonymous.jpg'),
    // Add more conversation data here
  ];

  void _navigateToNewMessageScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMessagePage(),
      ),
    );
  }

  List<Map<String, dynamic>> usersList = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUsers();
    getUserNickname();

    // Access other properties like displayName, photoURL, etc.
  }

  void getUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final email = currentUser?.email;
      final users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isNotEqualTo: email)
          .get();

      List<Map<String, dynamic>> usersWithRecentMessages = [];

      for (final user in users.docs) {
        final messageData = await fetchMessage(user['email']);

        if (messageData != null) {
          final message = messageData['message'];
          final time = messageData['time'];

          //converting time variable
          String timestring = time.toString();
          DateTime dateTime = DateTime.parse(timestring);
          String formattedDate = DateFormat('E HH:mm').format(dateTime);
          // Output: Wed 22:11
          usersWithRecentMessages.add({
            ...user.data(),
            'recentMessage': message,
            'time': formattedDate
          });
        }
      }

      setState(() {
        usersList = usersWithRecentMessages;
        loading = true;
      });
    } catch (e) {
      print('Error getting users: $e');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String message = '';

  Future fetchMessage(String otherEmail) async {
    final currentUser = _auth.currentUser;

    try {
      final messageDoc = await FirebaseFirestore.instance
          .collection('messages')
          .where('EmailFrom', isEqualTo: currentUser!.email)
          .where('EmailTo', whereIn: [otherEmail])
          .orderBy('Time', descending: true)
          .limit(1)
          .get();

      final otherMessageDoc = await FirebaseFirestore.instance
          .collection('messages')
          .where('EmailFrom', whereIn: [otherEmail])
          .where('EmailTo', isEqualTo: currentUser.email)
          .orderBy('Time', descending: true)
          .limit(1)
          .get();

      String recentMessage = "";
      DateTime recentMessageTime = DateTime.fromMillisecondsSinceEpoch(0);
      if (messageDoc.docs.isNotEmpty || otherMessageDoc.docs.isNotEmpty) {
        final timestamp1 = messageDoc.docs.isNotEmpty
            ? messageDoc.docs.first.data()['Time']
            : Timestamp(0, 0);
        final timestamp2 = otherMessageDoc.docs.isNotEmpty
            ? otherMessageDoc.docs.first.data()['Time']
            : Timestamp(0, 0);

        if (timestamp1.compareTo(timestamp2) > 0) {
          recentMessage = messageDoc.docs.first.data()['Content'];
          recentMessageTime = messageDoc.docs.first.data()['Time'].toDate();
        } else if (timestamp1.compareTo(timestamp2) < 0) {
          recentMessage = otherMessageDoc.docs.first.data()['Content'];
          recentMessageTime =
              otherMessageDoc.docs.first.data()['Time'].toDate();
        }

        return {
          'message': recentMessage,
          'time': recentMessageTime,
        };
      }
    } catch (e) {
      print('Error fetching message: $e');
    }
  }

  Future getUserNickname() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final email = currentUser?.email;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    String nickname = '';
    if (snapshot.docs.isNotEmpty) {
      nickname = snapshot.docs.first.data()['nickname'];
    } else {
      nickname = '';
    }

    setState(() {
      username = nickname;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomLogoContainer(),
              CustomNavBar(username),
              const SizedBox(height: 16.0),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors
                      .grey[200], // Replace with your desired background color
                  borderRadius: BorderRadius.circular(
                      8), // Replace with your desired border radius
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Quote of the Day',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      quote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 19),
              Container(
                decoration: BoxDecoration(
                  color: Colors
                      .grey[200], // Replace with your desired background color
                  borderRadius: BorderRadius.circular(
                      10), // Replace 10 with your desired border radius
                ), // Replace with your desired background color
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, size: 30),
                            onPressed: () {
                              _navigateToNewMessageScreen(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child: loading
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: usersList
                                    .length, // Replace with your conversations list
                                itemBuilder: (context, index) {
                                  final user = usersList[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ChatPage(
                                                  email: user['email'],
                                                  gender: user['gender'])));
                                      // Handle conversation item click
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'lib/images/anonymous.jpg'),
                                      ),
                                      title: Text(
                                        user['nickname'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      subtitle: Text(user['recentMessage']),
                                      trailing: Text(
                                        user['time'].toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Loading..."),
                                    SizedBox(height: 20),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              )),
                  ],
                ),
              ),

              // Rest of the home page content
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Handle navigation to different pages based on the index
          if (_currentIndex == 0) {
            // Navigate to the Home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (_currentIndex == 1) {
            // Navigate to the Contacts page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewMessagePage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],
      ),
    );
  }
}

class CustomLogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'lib/images/logo PSC 16.png', // Replace with the path to your custom logo image
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}

class Conversation {
  final String name;
  final String message;
  final DateTime time;
  String imageUrl;
  Conversation(this.name, this.message, this.time, this.imageUrl);
}
