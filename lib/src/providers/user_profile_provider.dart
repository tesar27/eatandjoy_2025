import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enj/src/services/user_profile_service.dart';
import 'package:enj/src/appwrite/providers.dart';

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  final account = ref.watch(accountProvider);
  final databases = ref.watch(databaseProvider);
  return UserProfileService(account, databases);
});

final userProfileProvider = FutureProvider<User>((ref) async {
  final userProfileService = ref.watch(userProfileServiceProvider);
  return await userProfileService.getUserProfile();
});
