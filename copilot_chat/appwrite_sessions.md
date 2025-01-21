I understand your requirement now. You need to have two separate clients: one for user-specific data manipulation (session client) and another for admin-level access (admin client). Let's ensure that the Flutter code serves the same purpose as your Next.js functions.

### Updated Flutter Code

We'll create two separate methods: `createSessionClient` and `createAdminClient`. Each method will return an object with the necessary Appwrite services (`Account`, `Databases`, `Storage`, `Avatars`).

### Updated `AppwriteService`

```dart


import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppwriteService {
  late Client client;

  AppwriteService() {
    client = Client()
      ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)
      ..setProject(dotenv.env['APPWRITE_PROJECT_ID']!);
  }

  Future<Map<String, dynamic>> createSessionClient() async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.getString('appwrite-session');

    if (session == null || session.isEmpty) {
      throw Exception("No session");
    }

    client.setJWT(session);

    return {
      'account': Account(client),
      'databases': Databases(client),
    };
  }

  Future<Map<String, dynamic>> createAdminClient() async {
    final secretKey = dotenv.env['APPWRITE_SECRET_KEY'];
    if (secretKey == null || secretKey.isEmpty) {
      throw Exception(
          "APPWRITE_SECRET_KEY is not set in the environment variables");
    }

    client.setKey(secretKey);

    return {
      'account': Account(client),
      'databases': Databases(client),
      'storage': Storage(client),
      'avatars': Avatars(client),
    };
  }
}

final appwriteServiceProvider = Provider((ref) => AppwriteService());
```

### Explanation

- **createSessionClient**: Initializes the Appwrite client with a session token stored in `SharedPreferences`. Returns an object containing `Account` and `Databases` services.
- **createAdminClient**: Initializes the Appwrite client with an API key. Returns an object containing `Account`, `Databases`, `Storage`, and `Avatars` services.

### Usage Example

Here's how you can use these methods in your Flutter application:

```dart
// Example usage in a Flutter widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/appwrite_service.dart';

class ExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appwriteService = ref.read(appwriteServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final sessionClient = await appwriteService.createSessionClient();
              final account = sessionClient['account'];
              final databases = sessionClient['databases'];

              // Use account and databases as needed
            } catch (e) {
              print('Error: $e');
            }

            try {
              final adminClient = await appwriteService.createAdminClient();
              final account = adminClient['account'];
              final databases = adminClient['databases'];
              final storage = adminClient['storage'];
              final avatars = adminClient['avatars'];

              // Use account, databases, storage, and avatars as needed
            } catch (e) {
              print('Error: $e');
            }
          },
          child: Text('Initialize Clients'),
        ),
      ),
    );
  }
}
```

### Summary

- **createSessionClient**: For user-specific data manipulation.
- **createAdminClient**: For admin-level access.
- Both methods return an object containing the necessary Appwrite services.

This setup ensures that you have separate clients for session-based and admin-based interactions, similar to your Next.js functions.