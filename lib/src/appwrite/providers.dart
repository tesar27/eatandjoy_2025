import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config.dart';

final clientProvider = Provider<Client>((ref) {
  return Client()
      .setEndpoint(AppwriteConfig.endpointUrl!)
      .setProject(AppwriteConfig.projectId!)
      .setSelfSigned();
});

final accountProvider = Provider<Account>((ref) {
  final client = ref.watch(clientProvider);
  return Account(client);
});

final databaseProvider = Provider<Databases>((ref) {
  final client = ref.watch(clientProvider);
  return Databases(client);
});
