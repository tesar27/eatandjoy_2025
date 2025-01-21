// filepath: /Users/yerbolattazhkeyev/Documents/Workspaces/Dec2024/flutter_1/enj/lib/src/settings/settings_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(SettingsState());

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void updateLanguage(String newLanguage) {
    state = state.copyWith(language: newLanguage);
  }

  void updateUsername(String newUsername) {
    state = state.copyWith(username: newUsername);
  }
}

class SettingsState {
  final bool isDarkMode;
  final String language;
  final String username;

  SettingsState({
    this.isDarkMode = false,
    this.language = 'en',
    this.username = 'User',
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    String? username,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      username: username ?? this.username,
    );
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});
