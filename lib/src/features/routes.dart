// filepath: /Users/yerbolattazhkeyev/Documents/Workspaces/Dec2024/flutter_1/enj/lib/src/features/routes.dart
import 'package:enj/src/features/home/views/home_view.dart';
import 'package:enj/src/features/login/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_view.dart';
import 'settings/settings_controller.dart';
import '../appwrite/auth_api.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) => const LoginScreen(),
      );
    case SettingsView.routeName:
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) => Consumer(
          builder: (context, ref, child) {
            ref.watch(settingsControllerProvider.notifier);
            return const SettingsView();
          },
        ),
      );
    case SampleItemDetailsView.routeName:
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) => const SampleItemDetailsView(),
      );
    case SampleItemListView.routeName:
    default:
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) => Consumer(
          builder: (context, ref, child) {
            final authState = ref.watch(isAuthenticatedProvider);
            return authState.when(
              data: (isAuthenticated) {
                if (isAuthenticated) {
                  return const HomeView(); // Redirect to main screen if authenticated
                } else {
                  return const LoginScreen(); // Redirect to login screen if not authenticated
                }
              },
              loading: () =>
                  const CircularProgressIndicator(), // Show loading indicator while checking authentication
              error: (error, stack) =>
                  const LoginScreen(), // Redirect to login screen if there's an error
            );
          },
        ),
      ); //()
  }
}
