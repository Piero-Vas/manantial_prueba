import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manantial_prueba/core/injection.dart';
import 'package:manantial_prueba/core/pages.dart';
import 'package:manantial_prueba/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerSingleton<String>('https://mocki.io/v1/c5a90d24-be6d-480c-95cc-3d5deb95ed46');
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<EventsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Manantial Prueba',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/root',
        routes: {
          '/root': (context) => RootPage(),
          '/': (context) => LoginPage(),
          '/events': (context) => const EventsPage(),
        },
      ),
    );
  }
}
