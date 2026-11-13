import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:node/app.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/shared/widgets/animated_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  final TextEditingController _name = TextEditingController();

  bool isPasswordHidden = false;

  Future<void> addUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': _name.text,
        'authorId': user?.uid,
        'collegeId': 'iiitbh',
        'email': _email.text,
        'nodesCreated': 0,
        'starsEarned': 0,
        'joinedClusters': [],
      });
    } on FirebaseException catch (e) {
      throw e.toString();
    }
  }

  Future<void> register(BuildContext context) async {
    if (_email.text.trim().isEmpty ||
        _name.text.trim().isEmpty ||
        _pass.text.trim().isEmpty) {
      throw 'Credentials Empty';
    }
    UserCredential cred;
    try {
      cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('An account already exists with this email.');
        case 'weak-password':
          throw Exception('Password is too weak.');
        case 'invalid-email':
          throw Exception('Please enter a valid email address.');
        case 'network-request-failed':
          throw Exception('Network error. Check your connection.');
        default:
          throw Exception('Registration failed. Please try again.');
      }
    }
    try {
      await addUser();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (conext) => App()),
        (route) => false,
      );
      final snackbar = SnackBar(content: Text('Registration Successful'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } catch (e) {
      await cred.user?.delete();
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Lottie.asset(
                'assets/animations/crab.json',
                height: 200,
                width: 350,
                fit: BoxFit.cover,
              ),
              Text(
                'Register!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pass,
                obscureText: !isPasswordHidden,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: (isPasswordHidden)
                        ? const Icon(LucideIcons.eye)
                        : const Icon(LucideIcons.eyeOff),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // FilledButton(
              //   onPressed: () {
              //     register(context);
              //   },
              //   child: (isRegistering)
              //       ? Center(child: CircularProgressIndicator())
              //       : Text('Signup', style: TextStyle(fontSize: 24)),
              // ),
              AnimatedAuthButton(
                label: 'Sign In',
                onPressed: () async {
                  // This delay simulates network latency.
                  // Replace with actual FirebaseAuth sign-in logic.
                  await register(context);

                  // If the authentication throws an error, the button will
                  // automatically expand back to the "idle" state.
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  Text('Already have an account'),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (conext) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Text('Login'),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
