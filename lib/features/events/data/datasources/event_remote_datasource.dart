import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_isar_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventIsarModel>> fetchEvents();
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final String apiUrl;
  EventRemoteDataSourceImpl({required this.apiUrl});

  @override
  Future<List<EventIsarModel>> fetchEvents() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => EventIsarModel(
        id: e['id'],
        description: e['description'],
        latitude: e['coordinates']['latitude'],
        longitude: e['coordinates']['longitude'],
        isFavorite: e['is_favorite'],
        enableAlert: e['enable_alert'],
        photoUrl: e['photo_url'],
        date: DateTime.parse(e['date']),
        locationDescription: e['location_description'],
      )).toList();
    } else {
      throw Exception('Error al obtener eventos de la API');
    }
  }
}
