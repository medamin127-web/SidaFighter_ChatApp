import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/chat_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({Key? key}) : super(key: key);

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  List<User> userList = [];
  List<User> filteredUserList = [];

  void fetchUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final email = currentUser?.email;
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isNotEqualTo: email)
              .get();

      final List<User> users = snapshot.docs.map((doc) {
        final data = doc.data();

        return User(
            name: data['nickname'],
            image: 'lib/images/anonymous.jpg',
            email: data['email'],
            gender: data['gender']);
      }).toList();

      setState(() {
        userList = users;
        filteredUserList = users;
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredUserList = userList
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

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
        title: Text('New Message'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Contact',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: filterUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, index) {
                final user = filteredUserList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('lib/images/anonymous.jpg'),
                  ),
                  title: Text(user.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          email: user.email,
                          gender: user.gender,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String image;
  final String email;
  final String gender;

  User(
      {required this.name,
      required this.image,
      required this.email,
      required this.gender});
}
