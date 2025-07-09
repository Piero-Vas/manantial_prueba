import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventMapSheet extends StatelessWidget {
  final LatLng myPosition;
  final LatLng eventPosition;
  final String eventDescription;

  const EventMapSheet(
      {super.key,
      required this.myPosition,
      required this.eventPosition,
      required this.eventDescription});

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    void setMapBounds() {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          myPosition.latitude < eventPosition.latitude
              ? myPosition.latitude
              : eventPosition.latitude,
          myPosition.longitude < eventPosition.longitude
              ? myPosition.longitude
              : eventPosition.longitude,
        ),
        northeast: LatLng(
          myPosition.latitude > eventPosition.latitude
              ? myPosition.latitude
              : eventPosition.latitude,
          myPosition.longitude > eventPosition.longitude
              ? myPosition.longitude
              : eventPosition.longitude,
        ),
      );

      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  'Ubicación del evento: $eventDescription',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: GoogleMap(
                  compassEnabled: false,
                  zoomControlsEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: eventPosition, zoom: 14),
                  markers: {
                    Marker(
                        markerId: const MarkerId('me'),
                        position: myPosition,
                        infoWindow: const InfoWindow(title: 'Mi ubicación')),
                    Marker(
                        markerId: const MarkerId('event'),
                        position: eventPosition,
                        infoWindow: const InfoWindow(title: 'Evento')),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    setMapBounds();
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: [myPosition, eventPosition],
                      color: Colors.blue,
                      width: 4,
                    ),
                  },
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
