import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manantial_prueba/core/enums/mensaje_enum.dart';
import 'package:manantial_prueba/core/widgets/custom_button.dart';
import 'package:manantial_prueba/core/widgets/custom_input.dart';
import 'package:manantial_prueba/core/widgets/flash_message.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../presentation/bloc/auth_event.dart';
import '../presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingresa email y contraseña')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          LoginRequested(email: email, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          debugPrint('Error de autenticación: ${state.message}');
          mensaje(3, context, TypeMessage.danger,
              'Sucedió algo inesperado, por favor intenta nuevamente');
        }
        if (state is AuthSuccess) {
          mensaje(3, context, TypeMessage.success,
              'Bienvenido ${state.user.email}');
          Navigator.pushReplacementNamed(context, '/events');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FlutterLogo(size: 80),
                    SizedBox(height: 32),
                    CustomInput(
                      label: 'Correo electrónico',
                      controller: _emailController,
                    ),
                    SizedBox(height: 16),
                    CustomInput(
                      label: 'Contraseña',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 24),
                    CustomButton(
                      label: state is AuthLoading
                          ? 'Cargando...'
                          : 'Iniciar sesión',
                      onPressed: state is AuthLoading ? () {} : _onLoginPressed,
                      type: 'primary',
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('o'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      label: 'Continuar con Google',
                      onPressed: state is AuthLoading
                          ? () {}
                          : () {
                              context
                                  .read<AuthBloc>()
                                  .add(LoginWithGoogleRequested());
                            },
                      type: 'outline_primary',
                      icon: Image.asset('assets/img/google.png', height: 24),
                    ),
                    SizedBox(height: 12),
                    CustomButton(
                      label: 'Continuar con Hotmail',
                      onPressed: state is AuthLoading
                          ? () {}
                          : () {
                              context
                                  .read<AuthBloc>()
                                  .add(LoginWithMicrosoftRequested());
                            },
                      type: 'outline_secondary',
                      icon: Icon(Icons.email, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
