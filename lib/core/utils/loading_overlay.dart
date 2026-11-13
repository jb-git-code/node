import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay {
  // Show the overlay
  static void show(BuildContext context) {
    showDialog(
      context: context,
      // Prevents the user from closing it by tapping outside
      barrierDismissible: false,
      // Makes the background slightly darkened/blurred
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => const _LoadingWidget(),
    );
  }

  // Hide the overlay
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    // WillPopScope prevents the Android back button from dismissing the loader
    return PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Lottie.asset(
                'assets/animations/node_connect.json', // Your consistent animation
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
