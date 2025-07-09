import '../entities/event.dart';

abstract class EventRepository {
  Future<void> saveEvents(List<Event> events);
  Future<List<Event>> getAllEvents();
  Future<void> deleteEvent(int id);
  Future<void> updateEvent(Event event);
  Future<void> clearAll();
}
