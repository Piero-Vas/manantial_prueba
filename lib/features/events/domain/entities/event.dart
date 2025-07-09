class Event {
  final int id;
  final String description;
  final double latitude;
  final double longitude;
  final bool isFavorite;
  final bool enableAlert;
  final String photoUrl;
  final DateTime date;
  final String locationDescription;

  Event({
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
