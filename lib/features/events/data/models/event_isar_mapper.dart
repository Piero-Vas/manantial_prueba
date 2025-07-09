import '../../domain/entities/event.dart';
import 'event_isar_model.dart';

extension EventIsarMapper on EventIsarModel {
  Event toDomain() => Event(
        id: id,
        description: description,
        latitude: latitude,
        longitude: longitude,
        isFavorite: isFavorite,
        enableAlert: enableAlert,
        photoUrl: photoUrl,
        date: date,
        locationDescription: locationDescription,
      );
}

extension EventDomainMapper on Event {
  EventIsarModel toIsarModel() => EventIsarModel(
        id: id,
        description: description,
        latitude: latitude,
        longitude: longitude,
        isFavorite: isFavorite,
        enableAlert: enableAlert,
        photoUrl: photoUrl,
        date: date,
        locationDescription: locationDescription,
      );
}
