import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailAndPassword {
  final AuthRepository repository;

  LoginWithEmailAndPassword(this.repository);

  Future<User> call({required String email, required String password}) {
    return repository.loginWithEmailAndPassword(email: email, password: password);
  }
}
