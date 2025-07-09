import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manantial_prueba/core/widgets/custom_button.dart';
import 'package:manantial_prueba/features/events/domain/entities/event.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_bloc.dart';
import 'package:manantial_prueba/features/events/presentation/bloc/events_event.dart';

class EventFormPage extends StatefulWidget {
  final Event? initialEvent;
  const EventFormPage({Key? key, this.initialEvent}) : super(key: key);

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _locationDescriptionController;
  late TextEditingController _photoUrlController;
  DateTime _selectedDate = DateTime.now();
  bool _enableAlert = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.initialEvent?.description ?? '');
    _locationDescriptionController = TextEditingController(
        text: widget.initialEvent?.locationDescription ?? '');
    _photoUrlController =
        TextEditingController(text: widget.initialEvent?.photoUrl ?? '');
    _enableAlert = widget.initialEvent?.enableAlert ?? false;
    _isFavorite = widget.initialEvent?.isFavorite ?? false;
    _selectedDate = widget.initialEvent?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationDescriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;
    final event = Event(
      id: widget.initialEvent?.id ?? DateTime.now().millisecondsSinceEpoch,
      description: _descriptionController.text.trim(),
      latitude:
          widget.initialEvent?.latitude ?? 0.0, // TODO: obtener ubicación real
      longitude:
          widget.initialEvent?.longitude ?? 0.0, // TODO: obtener ubicación real
      isFavorite: _isFavorite,
      enableAlert: _enableAlert,
      photoUrl: _photoUrlController.text.trim(),
      date: _selectedDate,
      locationDescription: _locationDescriptionController.text.trim(),
    );
    if (widget.initialEvent == null) {
      context.read<EventsBloc>().add(AddEvent(event));
    } else {
      context.read<EventsBloc>().add(UpdateEvent(
            event.id,
            {
              'description': event.description,
              'latitude': event.latitude,
              'longitude': event.longitude,
              'isFavorite': event.isFavorite,
              'enableAlert': event.enableAlert,
              'photoUrl': event.photoUrl,
              'date': event.date,
              'locationDescription': event.locationDescription,
            },
          ));
    }
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialEvent == null ? 'Agregar evento' : 'Editar evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationDescriptionController,
                decoration:
                    InputDecoration(labelText: 'Referencia de ubicación'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                decoration:
                    InputDecoration(labelText: 'URL de foto (opcional)'),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                    'Fecha: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SwitchListTile(
                value: _enableAlert,
                onChanged: (v) => setState(() => _enableAlert = v),
                title: Text('Habilitar alerta'),
              ),
              SwitchListTile(
                value: _isFavorite,
                onChanged: (v) => setState(() => _isFavorite = v),
                title: Text('Marcar como favorito'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSave,
                child: Text(widget.initialEvent == null
                    ? 'Agregar'
                    : 'Guardar cambios'),
              ),
              CustomButton(
                  label: widget.initialEvent == null
                      ? 'Agregar'
                      : 'Guardar cambios',
                  onPressed: _onSave,
                  type: 'primary'),
            ],
          ),
        ),
      ),
    );
  }
}
