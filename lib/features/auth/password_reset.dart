import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:node/app.dart';
import 'package:node/features/feed/home.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/auth/signup.dart';

class PasswordReset extends StatelessWidget {
  PasswordReset({super.key});

  final TextEditingController _email = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (conext) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'Password Reset!',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  resetPassword(context);
                },
                child: Text('Reset', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
