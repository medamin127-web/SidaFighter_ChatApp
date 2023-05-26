import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';

class CustomNavBar extends StatelessWidget {
  final String username;

  CustomNavBar(this.username);

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      // Navigate to the login page after successful logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Error occurred during logout
      // Handle the error (e.g., show error message)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Error'),
            content: Text('An error occurred during logout.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red, // Set the background color to red
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Custom Logo
          Text(
            'SidaFighters',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          // Welcome back text
          Row(children: [
            Text(
              '$username',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(width: 8.0),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Edit Account'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Logout'),
                  value: 'logout',
                  onTap: () async {
                    await logout(context);
                  },
                ),
              ],
              onSelected: (String? value) {
                // Handle menu item selection
                if (value == 'edit') {
                  // Navigate to edit account screen
                }
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(
                    'lib/images/anonymous.jpg'), // Replace with your avatar image path
              ),
            ),
          ]),

          // User avatar with dropdown menu
        ],
      ),
    );
  }
}
