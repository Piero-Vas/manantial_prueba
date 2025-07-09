// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i5;
import 'package:manantial_prueba/core/network/network_info.dart' as _i6;
import 'package:manantial_prueba/core/register_module.dart' as _i16;
import 'package:manantial_prueba/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i7;
import 'package:manantial_prueba/features/auth/data/repositories/auth_repository_impl.dart'
    as _i9;
import 'package:manantial_prueba/features/auth/domain/repositories/auth_repository.dart'
    as _i8;
import 'package:manantial_prueba/features/auth/domain/usecases/login_with_email_and_password.dart'
    as _i14;
import 'package:manantial_prueba/features/auth/presentation/bloc/auth_bloc.dart'
    as _i15;
import 'package:manantial_prueba/features/events/data/datasources/event_local_datasource.dart'
    as _i10;
import 'package:manantial_prueba/features/events/data/datasources/event_remote_datasource.dart'
    as _i3;
import 'package:manantial_prueba/features/events/data/repositories/event_repository_impl.dart'
    as _i12;
import 'package:manantial_prueba/features/events/domain/repositories/event_repository.dart'
    as _i11;
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart'
    as _i13;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.EventRemoteDataSource>(
        () => _i3.EventRemoteDataSourceImpl(apiUrl: gh<String>()));
    gh.lazySingleton<_i4.FirebaseAuth>(() => registerModule.firebaseAuth);
    await gh.factoryAsync<_i5.Isar>(
      () => registerModule.isar,
      preResolve: true,
    );
    gh.factory<_i6.NetworkInfo>(() => _i6.NetworkInfoImpl());
    gh.factory<_i7.AuthRemoteDataSource>(
        () => _i7.AuthRemoteDataSource(gh<_i4.FirebaseAuth>()));
    gh.factory<_i8.AuthRepository>(
        () => _i9.AuthRepositoryImpl(gh<_i7.AuthRemoteDataSource>()));
    gh.factory<_i10.EventLocalDataSource>(
        () => _i10.EventLocalDataSourceImpl(gh<_i5.Isar>()));
    gh.factory<_i11.EventRepository>(() => _i12.EventRepositoryImpl(
          localDataSource: gh<_i10.EventLocalDataSource>(),
          remoteDataSource: gh<_i3.EventRemoteDataSource>(),
          networkInfo: gh<_i6.NetworkInfo>(),
        ));
    gh.factory<_i13.EventsBloc>(
        () => _i13.EventsBloc(gh<_i11.EventRepository>()));
    gh.factory<_i14.LoginWithEmailAndPassword>(
        () => _i14.LoginWithEmailAndPassword(gh<_i8.AuthRepository>()));
    gh.factory<_i15.AuthBloc>(() => _i15.AuthBloc(
        loginWithEmailAndPassword: gh<_i14.LoginWithEmailAndPassword>()));
    return this;
  }
}

class _$RegisterModule extends _i16.RegisterModule {}
