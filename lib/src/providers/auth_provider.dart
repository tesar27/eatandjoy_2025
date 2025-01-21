import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../features/profile/data/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(null) {
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await authService.getUser();
      state = User(name: user.name, email: user.email, phone: user.phone);
    } catch (e) {
      state = null;
    }
  }

  Future<void> login(String email) async {
    await authService.signUpWithEmail(email);
    await loadUser();
  }

  Future<void> logout() async {
    await authService.logout();
    state = null;
  }

  Future<void> createEmailToken(String email) async {
    await authService.sendEmailToken(email);
  }

  Future<void> verifyEmailToken(String userId, String otp) async {
    await authService.verifyEmailToken(userId, otp);
  }

  Future<void> updateUser(User user) async {
    // Update user data in Appwrite (implement as needed)
    state = user;
  }
}
