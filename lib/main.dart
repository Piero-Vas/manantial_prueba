import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manantial_prueba/core/pages.dart';
import 'package:manantial_prueba/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:manantial_prueba/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:manantial_prueba/features/auth/domain/usecases/login_with_email_and_password.dart';
import 'package:manantial_prueba/features/auth/presentation/bloc/auth_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginWithEmailAndPassword: LoginWithEmailAndPassword(
          AuthRepositoryImpl(
            AuthRemoteDataSource(fb.FirebaseAuth.instance),
          ),
        ),
      ),
      child: MaterialApp(
        title: 'Manantial Prueba',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          // Aquí puedes agregar más rutas si es necesario
        },
      ),
    );
  }
}
