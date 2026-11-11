import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:node/app.dart';
import 'package:node/features/feed/views/home.dart';
import 'package:node/features/auth/password_reset.dart';
import 'package:node/features/auth/signup.dart';
import 'package:node/shared/widgets/animated_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  bool isPasswordHidden = false;

  Future<void> login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication failed. Please try again.';

      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        errorMessage = 'Incorrect password or email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Check your connection.';
      }

      // Throw the clean message for the button to catch
      throw Exception(errorMessage);
    } catch (e) {
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
              const SizedBox(height: 40),
              Lottie.asset(
                'assets/animations/welcome.json',
                height: 290,
                width: 290,
                fit: BoxFit.fill,
              ),

              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineLarge,
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
              //     login(context);
              //   },
              //   child: Text('Login', style: TextStyle(fontSize: 24)),
              // ),
              AnimatedAuthButton(
                label: 'Sign In',
                onPressed: () async {
                  // This delay simulates network latency.
                  // Replace with actual FirebaseAuth sign-in logic

                  await login(context);
                  // await Future.delayed(const Duration(seconds: 2));

                  // If the authentication throws an error, the button will
                  // automatically expand back to the "idle" state.
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (conext) => PasswordReset()),
                      );
                    },
                    child: Text('Forgot Password'),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (conext) => SignupScreen()),
                        (route) => false,
                      );
                    },
                    child: Text('Register'),
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
