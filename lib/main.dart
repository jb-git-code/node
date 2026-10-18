import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/firebase_options.dart';
import 'package:node/providers/theme_provider.dart';
import 'package:node/screens/app.dart';
import 'package:node/screens/home.dart';
import 'package:node/screens/login.dart';
import 'package:node/screens/signup.dart';

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
    final themeValue = ref.watch(darkThemeProvider);
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      themeMode: (themeValue) ? ThemeMode.light : ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}
