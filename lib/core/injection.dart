import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:manantial_prueba/core/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();
