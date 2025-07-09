import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<User> loginWithGoogle() async {
    return await remoteDataSource.loginWithGoogle();
  }

  @override
  Future<User> loginWithMicrosoft() async {
    return await remoteDataSource.loginWithMicrosoft();
  }
}
