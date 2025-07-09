import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manantial_prueba/core/widgets/custom_button.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_event.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:manantial_prueba/features/events/presentation/no_connection_page.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EventsBloc>().add(LoadEvents());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        automaticallyImplyLeading: false, // No mostrar flecha atrás
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              // Cierra sesión de Firebase y limpia la BD local
              await fb.FirebaseAuth.instance.signOut();
              context.read<EventsBloc>().add(
                  ClearEvents()); // Debes crear este evento si quieres limpiar la BD
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
            if (state.events.isEmpty) {
              return const Center(child: Text('No hay eventos.'));
            }
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return Card(
                  child: ListTile(
                    title: Text(event.description),
                    subtitle: Text(event.locationDescription),
                    trailing:
                        Icon(event.isFavorite ? Icons.star : Icons.star_border),
                    onTap: () {
                      // Aquí puedes navegar a detalle o mapa
                    },
                  ),
                );
              },
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
        onPressed: () {
          // Aquí puedes abrir el formulario para agregar evento
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
