import 'package:flutter/material.dart';
import 'package:manantial_prueba/core/widgets/custom_button.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_event.dart';

class NoConnectionPage extends StatelessWidget {
  final String message;
  const NoConnectionPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                child: CustomButton(label: 'Reintentar', onPressed: () {
                  context.read<EventsBloc>().add(LoadEvents());
                }, type: 'primary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
