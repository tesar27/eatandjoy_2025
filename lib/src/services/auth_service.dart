import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:enj/src/providers/appwrite_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final AppwriteService appwriteService;
  final Uuid uuid = const Uuid();
  final Client client = Client();
  late final Account account;

  AuthService(this.appwriteService, this.account) {
    client
      ..setEndpoint(dotenv.env['APPWRITE_URL']!)
      ..setProject(dotenv.env['APPWRITE_PROJECT_ID']!);
    account = Account(client);
  }

  Future<void> loginWithEmailOTP(String email) async {
    await sendEmailToken(email);
  }

// tesar.public@gmail.com
  Future<void> sendEmailToken(String email) async {
    appwriteService.createAdminClient(); // Initialize the admin client
    try {
      Token token = await appwriteService.account.createEmailToken(
        userId: uuid.v4(),
        email: email,
      );
      print('Email token created: ${token}');
    } catch (e) {
      print('Error creating email token: $e');
      rethrow;
    }
  }

  Future<void> verifyEmailToken(String userId, String otp) async {
    try {
      await appwriteService.account.updateVerification(
        userId: userId,
        secret: otp,
      );
      print('Email verified successfully');
    } catch (e) {
      print('Error verifying email: $e');
      throw e;
    }
  }

  Future<void> signUpWithEmail(String email) async {
    try {
      await sendOTP(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendOTP(String email) async {
    try {
      await account.createEmailToken(
        userId: uuid.v4(),
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOTP(String userId, String secret) async {
    try {
      await account.createSession(userId: userId, secret: secret);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUser() async {
    // Implement the logic to get the user from Appwrite
    // For example:
    final user = await appwriteService.account.get();
    return user;
  }

  Future<void> login(String email, String password) async {
    // Implement the login logic
  }

  Future<void> logout() async {
    // Implement the logout logic
    await appwriteService.account.deleteSession(sessionId: 'current');
    await appwriteService.removeSession();
  }
}

final authServiceProvider = Provider(
    (ref) => AuthService(ref.read(appwriteServiceProvider), Account(Client())));
