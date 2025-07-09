import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_with_email_and_password.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailAndPassword loginWithEmailAndPassword;

  AuthBloc({required this.loginWithEmailAndPassword}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
    on<LoginWithGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginWithEmailAndPassword.repository.loginWithGoogle();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
    on<LoginWithMicrosoftRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginWithEmailAndPassword.repository.loginWithMicrosoft();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
