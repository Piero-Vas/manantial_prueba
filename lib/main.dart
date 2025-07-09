import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:manantial_prueba/core/network/network_info.dart';
import 'package:manantial_prueba/core/pages.dart';
import 'package:manantial_prueba/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:manantial_prueba/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:manantial_prueba/features/auth/domain/usecases/login_with_email_and_password.dart';
import 'package:manantial_prueba/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:manantial_prueba/features/events/data/datasources/event_local_datasource.dart';
import 'package:manantial_prueba/features/events/data/datasources/event_remote_datasource.dart';
import 'package:manantial_prueba/features/events/data/models/event_isar_model.dart';
import 'package:manantial_prueba/features/events/data/repositories/event_repository_impl.dart';
import 'package:manantial_prueba/features/events/domain/repositories/event_repository.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [EventIsarModelSchema],
    directory: dir.path,
  );
  // Instancias para el repositorio de eventos
  final localDataSource = EventLocalDataSourceImpl(isar);
  final remoteDataSource = EventRemoteDataSourceImpl(apiUrl: 'https://mocki.io/v1/c5a90d24-be6d-480c-95cc-3d5deb95ed46');
  final networkInfo = NetworkInfoImpl();
  final eventRepository = EventRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
  runApp(MyApp(eventRepository: eventRepository));
}

class MyApp extends StatelessWidget {
  final EventRepository eventRepository;
  const MyApp({super.key, required this.eventRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginWithEmailAndPassword: LoginWithEmailAndPassword(
              AuthRepositoryImpl(
                AuthRemoteDataSource(fb.FirebaseAuth.instance),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => EventsBloc(eventRepository),
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
