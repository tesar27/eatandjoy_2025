import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void toggleTheme(WidgetRef ref) {
  final currentTheme = ref.read(themeProvider);
  ref.read(themeProvider.notifier).state =
      currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
}
