import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_session.dart';

class TurnosScreen extends StatefulWidget {
  const TurnosScreen({super.key});

  @override
  State<TurnosScreen> createState() => _TurnosScreenState();
}

class _TurnosScreenState extends State<TurnosScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSpecialty;
  String? _selectedDoctor;
  int? _selectedTimeIndex;

  final List<String> _specialties = [
    'Clínica Médica',
    'Pediatría',
    'Odontología',
    'Traumatología',
    'Oftalmología',
  ];

  final Map<String, List<String>> _doctors = {
    'Clínica Médica': ['Dr. García', 'Dra. López'],
    'Pediatría': ['Dr. Martínez', 'Dra. Fernández'],
    'Odontología': ['Dr. Rodríguez'],
    'Traumatología': ['Dr. Pérez'],
    'Oftalmología': ['Dra. Sosa'],
  };

  final List<String> _times = [
    '08:00',
    '08:30',
    '09:00',
    '10:15',
    '11:00',
    '14:00',
    '15:30',
    '16:45',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnos Médicos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _prevStep,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                if (_currentStep < 2)
                  FilledButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Continuar'),
                  ),
                if (_currentStep == 2)
                  FilledButton(
                    onPressed: _confirmTurno,
                    child: const Text('Confirmar Turno'),
                  ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Atrás'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Especialidad y Profesional'),
            content: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Especialidad'),
                  initialValue: _selectedSpecialty,
                  items: _specialties
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedSpecialty = val;
                      _selectedDoctor = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_selectedSpecialty != null)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Profesional'),
                    initialValue: _selectedDoctor,
                    items: _doctors[_selectedSpecialty]!
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedDoctor = val);
                    },
                  ),
              ],
            ),
            isActive: _currentStep == 0,
            state: _currentStep > 0 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: const Text('Fecha y Hora'),
            content: Column(
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  onDateChanged: (date) => setState(() => _selectedDate = date),
                ),
                const Divider(),
                const Text('Horarios Disponibles:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(_times.length, (index) {
                    return ChoiceChip(
                      label: Text(_times[index]),
                      selected: _selectedTimeIndex == index,
                      onSelected: (selected) {
                        setState(
                          () => _selectedTimeIndex = selected ? index : null,
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
            isActive: _currentStep == 1,
            state: _currentStep > 1 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: const Text('Confirmación'),
            content: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _confirmRow('Especialidad:', _selectedSpecialty),
                  _confirmRow('Profesional:', _selectedDoctor),
                  _confirmRow(
                    'Fecha:',
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  _confirmRow(
                    'Hora:',
                    _selectedTimeIndex != null
                        ? _times[_selectedTimeIndex!]
                        : '-',
                  ),
                ],
              ),
            ),
            isActive: _currentStep == 2,
            state: StepState.editing,
          ),
        ],
      ),
    );
  }

  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep == 0 &&
        (_selectedSpecialty == null || _selectedDoctor == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }
    if (_currentStep == 1 && _selectedTimeIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione un horario')),
      );
      return;
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _confirmTurno() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('¡Turno Confirmado!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tu turno ha sido reservado con éxito.'),
            const SizedBox(height: 16),
            Text('Especialidad: $_selectedSpecialty'),
            Text('Profesional: $_selectedDoctor'),
            Text('Fecha: ${"${_selectedDate.day}/${_selectedDate.month}"}'),
            Text('Hora: ${_times[_selectedTimeIndex!]}'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              // Save to session
              context.read<UserSession>().addAppointment({
                'id': DateTime.now().toString(),
                'specialty': _selectedSpecialty,
                'doctor': _selectedDoctor,
                'date': "${_selectedDate.day}/${_selectedDate.month}",
                'time': _times[_selectedTimeIndex!],
              });

              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('Volver al Inicio'),
          ),
        ],
      ),
    );
  }

  Widget _confirmRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? ''),
        ],
      ),
    );
  }
}
