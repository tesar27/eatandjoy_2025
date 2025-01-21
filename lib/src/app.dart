import 'package:enj/src/features/login/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/settings/settings_controller.dart';
import 'features/routes.dart'; // Import the new routes file

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);

    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        // Add other supported locales here
      ],

      // Use the settingsController to determine the theme.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness:
            settingsState.isDarkMode ? Brightness.dark : Brightness.light,
      ),

      initialRoute: LoginScreen.routeName,
      // Define the route generation function.
      onGenerateRoute: (RouteSettings routeSettings) =>
          generateRoute(routeSettings),
    );
  }
}
