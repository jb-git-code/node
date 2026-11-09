import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:node/app.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/auth/providers/auth_state_providers.dart'; // If using Lottie

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the pure Firebase Auth state instead of the Firestore user data
    final authState = ref.watch(authChangeProvider);

    return authState.when(
      data: (user) {
        // If user is null, they are not logged in. Route to Login.
        if (user == null) {
          return  LoginScreen(); 
        }
        // If user exists, they are authenticated. Route to the App.
        return const App(); 
      },
      
      // YOUR CUSTOM LOADING ANIMATION GOES HERE
      // This shows immediately when the app launches while Firebase checks the token
      loading: () => Scaffold(
        backgroundColor: AppColors.backgroundLavender, // Match your theme
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use your Lottie, Rive, or a custom widget here
              Lottie.asset(
                'assets/animations/node_spinner.json', 
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                'Initializing Node...',
                style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Auth Error: $error')),
      ),
    );
  }
}