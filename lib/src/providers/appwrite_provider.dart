import 'package:appwrite/appwrite.dart';
import 'package:enj/src/config/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppwriteService {
  late Client client;

  AppwriteService();

  Future<void> createSessionClient() async {
    client = Client()
      ..setEndpoint(dotenv.env['APPWRITE_URL']!)
      ..setProject(dotenv.env['APPWRITE_PROJECT_ID']!);

    final prefs = await SharedPreferences.getInstance();
    final session = prefs.getString('appwrite-session');

    if (session == null || session.isEmpty) {
      throw Exception("No session");
    }

    client.setJWT(session);
  }

  void createAdminClient() {
    const endpoint = Env.url;
    const projectId = Env.project;
    const secretKey = Env.key;

    client = Client()
      ..setEndpoint(endpoint)
      ..setProject(projectId)
      ..setJWT(secretKey);
  }

  Account get account => Account(client);
  Databases get databases => Databases(client);
  Storage get storage => Storage(client);
  Avatars get avatars => Avatars(client);

  Future<void> saveSession(String session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appwrite-session', session);
  }

// Retrieve data
  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('appwrite-session');
  }

// Remove data
  Future<void> removeSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('appwrite-session');
  }
}

final appwriteServiceProvider = Provider((ref) => AppwriteService());
