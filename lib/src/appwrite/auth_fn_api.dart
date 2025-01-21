import 'package:appwrite/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authFnApiProvider = Provider<AuthApi>((ref) {
  return AuthApi();
});

class EmailTokenResponse {
  final String userId;
  final Token token;

  EmailTokenResponse({required this.userId, required this.token});
}

class AuthApi {
  final String baseUrl =
      'https://appwrite.yerbolat.com/v1/functions/6778a8eb00016b0195c4/executions';
  final String projectId = '670121e5000ab490489e'; // Your project ID

  Future<EmailTokenResponse> createEmailToken(String email) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-appwrite-project': projectId,
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EmailTokenResponse(
          userId: data['userId'], token: Token.fromMap(data['token']));
    } else {
      throw Exception('Failed to create email token: ${response.body}');
    }
  }

  Future<void> verifyEmailToken(String userId, String otp) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-appwrite-project': projectId,
      },
      body: jsonEncode({'userId': userId, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify email token: ${response.body}');
    }
  }

  Future<void> deleteAllSessions(String userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-appwrite-project': projectId,
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all sessions: ${response.body}');
    }
  }

  Future<Session> createSession(String userId, String secret) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-appwrite-project': projectId,
      },
      body: jsonEncode({'userId': userId, 'secret': secret}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Session.fromMap(data['session']);
    } else {
      throw Exception('Failed to create session: ${response.body}');
    }
  }
}
