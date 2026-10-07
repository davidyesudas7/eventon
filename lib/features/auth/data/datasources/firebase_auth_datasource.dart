import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth? _customFirebaseAuth;
  final GoogleSignIn? _customGoogleSignIn;

  FirebaseAuthDatasource({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _customFirebaseAuth = firebaseAuth,
       _customGoogleSignIn = googleSignIn;

  FirebaseAuth get _firebaseAuth {
    if (_customFirebaseAuth != null) return _customFirebaseAuth;
    if (Firebase.apps.isEmpty) {
      throw Exception(
        'Firebase is not initialized. Please configure firebase_options.dart or add google-services.json.',
      );
    }
    return FirebaseAuth.instance;
  }

  GoogleSignIn get _googleSignIn {
    return _customGoogleSignIn ?? GoogleSignIn();
  }

  /// Send Phone OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(FirebaseAuthException e) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  /// Confirm OTP Code and get Firebase User ID Token
  Future<String> confirmOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();
    if (idToken == null) {
      throw Exception('Failed to obtain Firebase ID Token from phone auth');
    }
    return idToken;
  }

  /// Sign in with Google and return Firebase ID Token
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in cancelled by user');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();
    if (idToken == null) {
      throw Exception('Failed to obtain Firebase ID Token from Google auth');
    }
    return idToken;
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    if (Firebase.apps.isNotEmpty) {
      try {
        await _firebaseAuth.signOut();
      } catch (_) {}
    }
  }
}
