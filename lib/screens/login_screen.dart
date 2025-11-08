import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/strings.dart';
import 'phone_auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool isSignUp = false;
  final _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _show(String text, {bool err = false}) {
    if (!mounted) return;
    final color = err ? Colors.redAccent : Colors.green;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  Future<void> _handleEmailSignIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _show('Please fill in all fields', err: true);
      return;
    }

    if (isSignUp && password != confirmPass) {
      _show('Passwords do not match', err: true);
      return;
    }

    setState(() => loading = true);
    try {
      if (isSignUp) {
        await _auth.signUpWithEmail(email, password);
        _show('Account created successfully');
      } else {
        await _auth.signInWithEmail(email, password);
        _show('Signed in successfully');
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _show(e.toString(), err: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => loading = true);
    try {
      await _auth.signInWithGoogle();
      if (mounted) {
        _show('Signed in with Google');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _show(e.toString(), err: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() => loading = true);
    try {
      await _auth.signInWithFacebook();
      if (mounted) {
        _show('Signed in with Facebook');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _show(e.toString(), err: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Create Account' : 'Sign in'),
        actions: [
          TextButton(
            onPressed: () => setState(() => isSignUp = !isSignUp),
            child: Text(isSignUp ? 'Sign in instead' : 'Create account'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (isSignUp) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _handleEmailSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isSignUp ? 'Create Account' : 'Sign in',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              if (!isSignUp) ...[
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.red),
                  label: Text(t(context, 'loginWithGoogle')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loading ? null : _handleGoogleSignIn,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  label: Text(t(context, 'loginWithFacebook')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loading ? null : _handleFacebookSignIn,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.phone_android, color: Colors.green),
                  label: const Text('Sign in with Phone'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loading
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PhoneAuthScreen(),
                            ),
                          ),
                ),
              ],
              const SizedBox(height: 20),
              if (loading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
