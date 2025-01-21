import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static String? endpointUrl = dotenv.env['APPWRITE_URL'];
  static String? projectId = dotenv.env['APPWRITE_PROJECT_ID'];
  static String? databaseId = dotenv.env['APPWRITE_DATABASE_ID'];
  static String? usersCollectionId = dotenv.env['APPWRITE_USERS_COLLECTION_ID'];
  static String? secretKey = dotenv.env['APPWRITE_SECRET_KEY'];
  static String? locale = 'en';
}
