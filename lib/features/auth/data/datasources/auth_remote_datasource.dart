import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource(this._firebaseAuth);

  Future<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = credential.user!;
    return User(id: fbUser.uid, email: fbUser.email ?? '');
  }

  Future<User> loginWithGoogle() async {
    await GoogleSignIn.instance.initialize(
        serverClientId:
            '56169598740-tq3qblithnv7qknb4d93dhvob1i40qk4.apps.googleusercontent.com');
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      // accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final fbUser = userCredential.user!;
    return User(id: fbUser.uid, email: fbUser.email ?? '');
  }

  Future<User> loginWithMicrosoft() async {
    final provider = fb.OAuthProvider('microsoft.com');
    final userCredential = await _firebaseAuth.signInWithProvider(provider);
    final fbUser = userCredential.user!;
    return User(id: fbUser.uid, email: fbUser.email ?? '');
  }
}
