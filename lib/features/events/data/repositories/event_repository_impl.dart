import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_local_datasource.dart';
import '../datasources/event_remote_datasource.dart';
import '../models/event_isar_mapper.dart';
import 'package:manantial_prueba/core/network/network_info.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource localDataSource;
  final EventRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  bool hasSynced = false;

  EventRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> saveEvents(List<Event> events) async {
    await localDataSource.saveEvents(events.map((e) => e.toIsarModel()).toList());
  }

  @override
  Future<List<Event>> getAllEvents() async {
    final local = await localDataSource.getAllEvents();
    if (local.isNotEmpty) {
      // Si ya hay datos locales, solo mostrar locales
      hasSynced = true;
      return local.map((e) => e.toDomain()).toList();
    }
    // Si no hay datos locales, intentar sincronizar con la API
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteEvents = await remoteDataSource.fetchEvents();
        await localDataSource.saveEvents(remoteEvents);
        hasSynced = true;
        final updatedLocal = await localDataSource.getAllEvents();
        return updatedLocal.map((e) => e.toDomain()).toList();
      } catch (_) {
        throw Exception('Error al sincronizar con la API.');
      }
    } else {
      throw Exception('No hay conexión a internet y no hay datos locales.');
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    await localDataSource.deleteEvent(id);
  }

  @override
  Future<void> updateEvent(Event event) async {
    await localDataSource.updateEvent(event.toIsarModel());
  }

  @override
  Future<void> clearAll() async {
    await localDataSource.clearAll();
    hasSynced = false;
  }
}
