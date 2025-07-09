import 'package:isar/isar.dart';

part 'event_isar_model.g.dart';

@collection
class EventIsarModel {
  Id id;
  String description;
  double latitude;
  double longitude;
  bool isFavorite;
  bool enableAlert;
  String photoUrl;
  DateTime date;
  String locationDescription;

  EventIsarModel({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isFavorite,
    required this.enableAlert,
    required this.photoUrl,
    required this.date,
    required this.locationDescription,
  });
}
