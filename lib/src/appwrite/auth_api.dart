// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:enj/src/appwrite/config.dart';
import 'package:enj/src/appwrite/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  final account = ref.watch(accountProvider);
  final databases = ref.watch(databaseProvider);
  return AuthApi(account, databases);
});

final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final authApi = ref.watch(authApiProvider);
  try {
    final user = await authApi.getCurrentAccount();
    return user.email.isNotEmpty;
  } catch (e) {
    return false;
  }
});

class EmailTokenResponse {
  final String userId;
  final Token token;

  EmailTokenResponse({required this.userId, required this.token});
}

class AuthApi {
  final Account account;
  final Databases databases;

  AuthApi(this.account, this.databases);

  Future<bool> checkUserByEmail(String email) async {
    try {
      print('checking the user:');
      final result = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId!,
        collectionId: AppwriteConfig.usersCollectionId!,
        queries: [Query.equal('email', email)],
      );
      print(result.documents.first.data);
      return result.documents.isNotEmpty;
    } catch (e) {
      handleError(e, 'Error checking account:');
      return false;
    }
  }

  void handleError(Object error, String message) {
    print('$message: ${error.toString()}');
    if (error is AppwriteException) {
      print('Appwrite Error Code: ${error.code}');
      print('Appwrite Error Message: ${error.message}');
    }
  }

  Future<String> sendEmailOTP(String email) async {
    // await Future.delayed(const Duration(seconds: 2)); //Simulate delay
    try {
      final session = await account.createEmailToken(
        userId: ID.unique(),
        email: email,
      );
      return session.userId;
    } catch (e) {
      handleError(e, "Failed to send email OTP");
      throw Exception('Failed to send email OTP');
    }
  }

  Future<String> createAccount(String email) async {
    final userExists = await checkUserByEmail(email);
    print('createAccount function triggered');
    try {
      final accountId = await sendEmailOTP(email);
      if (accountId.isEmpty) throw Exception("Failed to send an OTP");

      if (!userExists) {
        await databases.createDocument(
          databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
          collectionId: dotenv.env['APPWRITE_USERS_COLLECTION_ID']!,
          documentId: ID.unique(),
          data: {
            'email': email,
            'accountId': accountId,
          },
        );
      }
      return accountId;
    } catch (e) {
      handleError(e, 'Failed to create account');
      throw Exception('Failed to create account');
    }
  }

  Future<String> verifyEmailToken(String userId, String otp) async {
    try {
      print('Verifying email token for user: $userId with OTP: $otp');
      final session = await createSession(
        userId: userId,
        secret: otp,
      );
      // Store session in preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sessionId', session.$id);
      await prefs.setString('userId', session.userId);
      return session.$id;
    } catch (e) {
      print('Error verifying email token: $e');
      throw Exception('Failed to verify email token');
    }
  }

  Future<Session> createSession(
      {required String userId, required String secret}) async {
    try {
      await deleteExistingSessions();
      return await account.createSession(
        userId: userId,
        secret: secret,
      );
    } catch (e) {
      // Handle the error appropriately
      print('Error creating session: $e');
      throw Exception('Failed to create session');
    }
  }

  Future<void> deleteExistingSessions() async {
    try {
      await account.deleteSessions();
      print('All sessions deleted');
    } catch (e) {
      print('Error deleting existing sessions: $e');
      throw Exception('Failed to delete existing sessions');
    }
  }

  Future<User> getCurrentAccount() async {
    try {
      final accountDetails = await account.get();
      print(accountDetails.email);
      return accountDetails;
    } catch (e) {
      handleError(e, 'Failed to get current account');
      throw Exception('Failed to get current account');
    }
  }
}
