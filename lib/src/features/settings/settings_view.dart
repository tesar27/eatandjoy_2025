import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends ConsumerState<SettingsView> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    final settingsState = ref.read(settingsControllerProvider);
    _usernameController = TextEditingController(text: settingsState.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<ThemeMode>(
              value:
                  settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              onChanged: (ThemeMode? newThemeMode) {
                if (newThemeMode != null) {
                  settingsController.toggleTheme();
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
            DropdownButton<String>(
              value: settingsState.language,
              onChanged: (String? newLanguage) {
                if (newLanguage != null) {
                  settingsController.updateLanguage(newLanguage);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text('Spanish'),
                ),
              ],
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            ElevatedButton(
              onPressed: () {
                settingsController.updateUsername(_usernameController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
