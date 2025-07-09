import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User> loginWithGoogle();

  Future<User> loginWithMicrosoft();
}
