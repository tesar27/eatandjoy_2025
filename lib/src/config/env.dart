import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'APPWRITE_DATABASE_ID')
  static const String database = _Env.database;

  @EnviedField(varName: 'APPWRITE_PROJECT_ID')
  static const String project = _Env.project;

  @EnviedField(varName: 'APPWRITE_URL')
  static const String url = _Env.url;

  @EnviedField(varName: 'COLLECTION_USERS')
  static const String users = _Env.users;

  @EnviedField(varName: 'APPWRITE_KEY')
  static const String key = _Env.key;
}
