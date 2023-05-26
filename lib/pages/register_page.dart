import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';

import '../components/my_button.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 52, 52),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 52, 52),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          // First Page: Code Input
          StepOne(
            onStepCompleted: () {
              if (_code == 'sida2023') {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Invalid Code'),
                    content: Text('Please enter a valid code.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            onCodeChanged: (code) {
              setState(() {
                _code = code;
              });
            },
          ),
          // Second Page: Additional Information
          StepTwo(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}

class StepOne extends StatelessWidget {
  final Function() onStepCompleted;
  final ValueChanged<String> onCodeChanged;

  StepOne({
    required this.onStepCompleted,
    required this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.info,
                color: Colors.blue,
              ),
              SizedBox(
                  width: 8.0), // Adjust the spacing between the icon and text
              Text(
                'In order to be granted sign-up access, you need to submit an entry code',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22.0),
          TextField(
            onChanged: onCodeChanged,
            obscureText: false,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'code',
                hintStyle: TextStyle(color: Colors.grey[500])),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onStepCompleted,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

class StepTwo extends StatefulWidget {
  final Function()? onTap;

  const StepTwo({Key? key, this.onTap}) : super(key: key);

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  String _selectedGender = '';
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  Future signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        // create user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get the newly created user's UID
        String uid = userCredential.user!.uid;

        //add user details
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'nickname': nicknameController.text
              .trim(), // Replace with the actual nickname entered by the user
          'email': emailController.text
              .trim(), // Replace with the actual email entered by the user
          'gender': _selectedGender,
          'doctor': 'No' // Replace with the actual selected gender
          // Add other user details as needed
        });
      } else {
        // show error message , passwords don't match
        passwordsUnmatching();
      }

      Navigator.pop(context);
      // User authentication successful, navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (emailController.text.isEmpty) {
        wrongInfoMessage();
      }
    }
  }

  Future addUserDetails(String nickname, String gender, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': 'email'
      // other additional fields
    });
  }

  void passwordsUnmatching() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.redAccent,
          title: Center(
            child: Text(
              "Passwords don't match!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void wrongInfoMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.redAccent,
          title: Center(
            child: Text(
              'Incorrect Login Info',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.lock,
                size: 60,
              ),
              const SizedBox(height: 19),
              const Text(
                'Let\'s create an account for you!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Nickname',
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500])),
              ),

              const SizedBox(height: 16.0),
              // Add your additional form fields here
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500])),
              ),

              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500])),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500])),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    'Choose Your Gender:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(width: 16.0),
                  const Text(
                    'Male',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  Radio<String>(
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16.0),
                  const Text(
                    'Female',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // sign in button
              MyButton(onTap: signUserUp, text: "Sign Up"),

              const SizedBox(height: 30),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
