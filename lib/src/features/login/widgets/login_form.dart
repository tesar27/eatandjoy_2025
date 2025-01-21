import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appwrite/auth_api.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  String? _userId;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        final userId = await ref.read(authApiProvider).createAccount(email);
        if (!mounted) return;
        setState(() {
          _isOtpSent = true;
          _userId = userId;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent to $email')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  void _login() async {
    final otp = _otpController.text.trim();
    if (otp.isNotEmpty && _userId != null) {
      try {
        await ref.read(authApiProvider).verifyEmailToken(_userId!, otp);
        // await ref.read(authApiProvider).createSession(_userId!, otp);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
    }
  }

  void _getUser() async {
    final res = await ref.read(authApiProvider).getCurrentAccount();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController..text = 'tesar.public@gmail.com',
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        if (_isOtpSent)
          TextField(
            controller: _otpController,
            decoration: const InputDecoration(
              labelText: 'OTP',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isOtpSent ? _login : _sendOtp,
          child: Text(_isOtpSent ? 'Login' : 'Send OTP'),
        ),
        ElevatedButton(
          onPressed: _getUser,
          child: const Text('Get User'),
        ),
      ],
    );
  }
}
