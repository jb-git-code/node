import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final darkThemeProvider = StateProvider<bool>((ref) => false);

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);