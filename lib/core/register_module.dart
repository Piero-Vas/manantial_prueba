import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'package:manantial_prueba/features/events/data/models/event_isar_model.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @preResolve
  Future<Isar> get isar async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([EventIsarModelSchema], directory: dir.path);
  }
}
