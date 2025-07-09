import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import 'events_event.dart';
import 'events_state.dart';

@injectable
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventRepository repository;
  EventsBloc(this.repository) : super(EventsInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventsLoading());
      try {
        final events = await repository.getAllEvents();
        emit(EventsLoaded(events));
      } catch (e) {
        emit(EventsError(e.toString()));
      }
    });
    on<DeleteEvent>((event, emit) async {
      if (state is EventsLoaded) {
        await repository.deleteEvent(event.id);
        final events = await repository.getAllEvents();
        emit(EventsLoaded(events));
      }
    });
    on<UpdateEvent>((event, emit) async {
      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        final idx = currentState.events.indexWhere((e) => e.id == event.id);
        if (idx != -1) {
          final eventToUpdate = currentState.events[idx];
          final updatedEvent = Event(
            id: eventToUpdate.id,
            description:
                event.changes['description'] ?? eventToUpdate.description,
            latitude: event.changes['latitude'] ?? eventToUpdate.latitude,
            longitude: event.changes['longitude'] ?? eventToUpdate.longitude,
            isFavorite: event.changes['isFavorite'] ?? eventToUpdate.isFavorite,
            enableAlert:
                event.changes['enableAlert'] ?? eventToUpdate.enableAlert,
            photoUrl: event.changes['photoUrl'] ?? eventToUpdate.photoUrl,
            date: event.changes['date'] ?? eventToUpdate.date,
            locationDescription: event.changes['locationDescription'] ??
                eventToUpdate.locationDescription,
          );
          await repository.updateEvent(updatedEvent);
          final events = await repository.getAllEvents();
          emit(EventsLoaded(events));
        }
      }
    });
    on<AddEvent>((event, emit) async {
      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        final newEvents = List<Event>.from(currentState.events)
          ..add(event.event as Event);
        await repository.saveEvents(newEvents);
        emit(EventsLoaded(newEvents));
      } else {
        await repository.saveEvents([event.event as Event]);
        final events = await repository.getAllEvents();
        emit(EventsLoaded(events));
      }
    });
    on<RefreshEvents>((event, emit) async {
      add(LoadEvents());
    });
    on<ClearEvents>((event, emit) async {
      await repository.clearAll();
      emit(EventsInitial());
    });
  }
}
