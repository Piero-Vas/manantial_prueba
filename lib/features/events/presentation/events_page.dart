import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manantial_prueba/core/colors.dart';
import 'package:manantial_prueba/core/enums/mensaje_enum.dart';
import 'package:manantial_prueba/core/widgets/custom_button.dart';
import 'package:manantial_prueba/core/widgets/flash_message.dart';
import 'package:manantial_prueba/features/events/domain/entities/event.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_event.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:manantial_prueba/features/events/presentation/event_form_page.dart';
import 'package:manantial_prueba/features/events/presentation/no_connection_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manantial_prueba/features/events/presentation/widgets/event_map_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Position?> _getPositionWithPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        mensaje(3, context, TypeMessage.warning,
            'Permiso de ubicación denegado. Intenta nuevamente.');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      mensaje(3, context, TypeMessage.warning,
          'Permiso de ubicación denegado permanentemente. Actívalo desde ajustes.');
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _showMapSheet(BuildContext context, Event event) async {
    final position = await _getPositionWithPermission(context);
    if (position == null) {
      mensaje(
          3, context, TypeMessage.danger, 'No se pudo obtener la ubicación');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EventMapSheet(
        myPosition: LatLng(position.latitude, position.longitude),
        eventPosition: LatLng(event.latitude, event.longitude),
        eventDescription: event.description,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Event event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar evento'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este evento?'),
        actions: [
          CustomButton(
            label: 'Cancelar',
            onPressed: () => Navigator.pop(context, false),
            type: 'outline_secondary',
          ),
          const SizedBox(height: 15),
          CustomButton(
            label: 'Eliminar',
            onPressed: () => Navigator.pop(context, true),
            type: 'primary',
            textColorApp: AppColors.white,
            backgroundColorApp: AppColors.red,
          ),
        ],
      ),
    );
    if (confirm == true) {
      context.read<EventsBloc>().add(DeleteEvent(event.id));
    }
  }

  Future<void> _callPhone(BuildContext context, Event event) async {
    final phone = '+51 931883801';
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      mensaje(3, context, TypeMessage.danger, 'No se pudo iniciar la llamada');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<EventsBloc>().add(LoadEvents());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await fb.FirebaseAuth.instance.signOut();
              context.read<EventsBloc>().add(ClearEvents());
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventsLoaded) {
            final events = (_searchText.length >= 3)
                ? state.events
                    .where((e) => e.description
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()))
                    .toList()
                : state.events;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por descripción...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                if (events.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Text('No hay eventos.'),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          child: Slidable(
                            key: ValueKey(event.id),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) =>
                                      _showMapSheet(context, event),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.map,
                                ),
                                SlidableAction(
                                  onPressed: (_) =>
                                      _confirmDelete(context, event),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                                SlidableAction(
                                  onPressed: (_) => _callPhone(context, event),
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.phone,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(event.description),
                              subtitle: Text(event.locationDescription),
                              trailing: Icon(event.isFavorite
                                  ? Icons.star
                                  : Icons.star_border),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EventFormPage(initialEvent: event),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          } else if (state is EventsError) {
            return Builder(
              builder: (context) => NoConnectionPage(
                message: 'No se pudo conectar a Internet',
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
