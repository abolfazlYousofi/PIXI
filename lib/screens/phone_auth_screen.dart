import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  bool _codeSent = false;
  String? _verificationId;
  int? _resendToken;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showMessage(String text, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  Future<void> _verifyPhone() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showMessage('Please enter a phone number', error: true);
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          await _signInWithCredential(credential);
        },
        onVerificationFailed: (FirebaseAuthException e) {
          setState(() => _loading = false);
          _showMessage(e.message ?? 'Verification failed', error: true);
        },
        onCodeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _codeSent = true;
            _loading = false;
          });
          _showMessage('OTP sent to $phone');
        },
        onCodeAutoRetrievalTimeout: (String verificationId) {
          setState(() => _loading = false);
          _showMessage('Code verification timeout', error: true);
        },
      );
    } catch (e) {
      setState(() => _loading = false);
      _showMessage(e.toString(), error: true);
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _showMessage('Please enter the OTP', error: true);
      return;
    }

    if (_verificationId == null) {
      _showMessage('Verification ID not found', error: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      setState(() => _loading = false);
      _showMessage(e.toString(), error: true);
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithPhone(credential);
      if (mounted) {
        _showMessage('Successfully signed in');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      _showMessage(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_codeSent ? 'Enter OTP' : 'Phone Sign In'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_codeSent) ...[
              const Text(
                'Enter your phone number to receive a verification code',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+1234567890',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyPhone,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Send Code'),
              ),
            ] else ...[
              const Text(
                'Enter the 6-digit code sent to your phone',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Verification Code',
                  prefixIcon: const Icon(Icons.lock_clock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyOTP,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Verify Code'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed:
                    _loading ? null : () => setState(() => _codeSent = false),
                child: const Text('Change Phone Number'),
              ),
            ],
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
