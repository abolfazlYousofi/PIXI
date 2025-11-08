import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Phone number verification
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String, int?) onCodeSent,
    required Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: onVerificationCompleted,
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with phone credential
  Future<UserCredential> signInWithPhone(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      await _saveUserData(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Email/Password Sign Up
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserData(credential.user!);
      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Email/Password Sign In
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign in aborted';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _saveUserData(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Facebook Sign In
  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status != LoginStatus.success) {
        throw 'Facebook sign in failed: ${result.status}';
      }

      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential = await _auth.signInWithCredential(credential);
      await _saveUserData(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastSignIn': FieldValue.serverTimestamp(),
        'provider': user.providerData.isNotEmpty
            ? user.providerData[0].providerId
            : 'unknown',
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user data: $e');
      // Don't throw here to avoid blocking auth flow
    }
  }

  // Handle Authentication Errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'Email is already registered.';
        case 'invalid-email':
          return 'Email address is invalid.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'network-request-failed':
          return 'Network error. Check your connection.';
        default:
          return 'Authentication error: ${error.message}';
      }
    }
    return error.toString();
  }
}
