import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:node/app.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_ui_config.dart';

enum ButtonState { idle, loading, success }

class AnimatedAuthButton extends StatefulWidget {
  final String label;
  final Future<void> Function() onPressed;

  const AnimatedAuthButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedAuthButton> createState() => _AnimatedAuthButtonState();
}

class _AnimatedAuthButtonState extends State<AnimatedAuthButton> {
  ButtonState _state = ButtonState.idle;

  void _submit() async {
    if (_state != ButtonState.idle) return;

    setState(() => _state = ButtonState.loading);

    try {
      await widget.onPressed();
      if (mounted) {
        setState(() => _state = ButtonState.success);
      }
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => App()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _state = ButtonState.idle);

      // 1. Clean up the error text (removes the "Exception: " prefix)
      final errorMessage = e.toString().replaceAll('Exception: ', '');

      // 2. Display the error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            // style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.error, // Or use your AppColors.error
          behavior: SnackBarBehavior.floating, // Makes it look modern
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _state == ButtonState.idle;
    final isSuccess = _state == ButtonState.success;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // Shrink width to form a circle when loading or success
        width: isIdle ? MediaQuery.of(context).size.width : 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSuccess
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.primary,
          borderRadius: isIdle ? AppUI.cardRadius : BorderRadius.circular(25),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: isIdle ? AppUI.cardRadius : BorderRadius.circular(25),
            onTap: _submit,
            child: Center(child: _buildChild(isIdle, isSuccess)),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(bool isIdle, bool isSuccess) {
    if (isIdle) {
      return Text(
        widget.label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    } else if (isSuccess) {
      return const Icon(LucideIcons.check, color: AppColors.surfaceWhite);
    } else {
      // THE ANIMATION SLOT
      // Replace this native spinner with your vector animation:
      // return Lottie.asset('assets/animations/loading.json');
      // return const RiveAnimation.asset('assets/animations/spinner.riv');
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onSurface,
          strokeWidth: 2.5,
        ),
      );
    }
  }
}
