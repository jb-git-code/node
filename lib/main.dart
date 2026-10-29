import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/features/feed/views/edge_screen.dart';
import 'package:node/firebase_options.dart';
import 'package:node/core/themes/providers/theme_provider.dart';
import 'package:node/app.dart';
import 'package:node/features/feed/views/home.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/auth/password_reset.dart';
import 'package:node/features/auth/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themePro = ref.watch(themeModeProvider);
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: themePro,
      debugShowCheckedModeBanner: false,
      home: EdgeScreen(),
    );
  }
}
