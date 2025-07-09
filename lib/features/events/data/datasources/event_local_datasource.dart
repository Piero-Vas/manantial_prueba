import 'package:isar/isar.dart';
import 'package:injectable/injectable.dart';
import '../models/event_isar_model.dart';

abstract class EventLocalDataSource {
  Future<void> saveEvents(List<EventIsarModel> events);
  Future<List<EventIsarModel>> getAllEvents();
  Future<void> deleteEvent(int id);
  Future<void> updateEvent(EventIsarModel event);
  Future<void> clearAll();
}

@Injectable(as: EventLocalDataSource)
class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Isar isar;
  EventLocalDataSourceImpl(this.isar);

  @override
  Future<void> saveEvents(List<EventIsarModel> events) async {
    await isar.writeTxn(() async {
      await isar.eventIsarModels.putAll(events);
    });
  }

  @override
  Future<List<EventIsarModel>> getAllEvents() async {
    return await isar.eventIsarModels.where().findAll();
  }

  @override
  Future<void> deleteEvent(int id) async {
    await isar.writeTxn(() async {
      await isar.eventIsarModels.delete(id);
    });
  }

  @override
  Future<void> updateEvent(EventIsarModel event) async {
    await isar.writeTxn(() async {
      await isar.eventIsarModels.put(event);
    });
  }

  @override
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.eventIsarModels.clear();
    });
  }
}
