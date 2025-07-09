import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventsEvent {}

class RefreshEvents extends EventsEvent {}

class DeleteEvent extends EventsEvent {
  final int id;
  const DeleteEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class UpdateEvent extends EventsEvent {
  final int id;
  final Map<String, dynamic> changes;
  const UpdateEvent(this.id, this.changes);
  @override
  List<Object?> get props => [id, changes];
}

class AddEvent extends EventsEvent {
  final dynamic event;
  const AddEvent(this.event);
  @override
  List<Object?> get props => [event];
}

class ClearEvents extends EventsEvent {
  const ClearEvents();
  @override
  List<Object?> get props => [];
}
