import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_session.dart';

class MyTurnsScreen extends StatelessWidget {
  const MyTurnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Turnos')),
      body: Consumer<UserSession>(
        builder: (context, session, child) {
          if (session.appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text('No tenés turnos programados'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Sacar un turno'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: session.appointments.length,
            itemBuilder: (context, index) {
              final turn = session.appointments[index];
              return Dismissible(
                key: Key(turn['id'] ?? index.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.cancel, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Cancelar Turno'),
                      content: const Text(
                        '¿Estás seguro que deseas cancelar este turno?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('No'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Sí, cancelar'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  session.removeAppointment(turn['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Turno cancelado')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(
                        Icons.medical_services,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text('${turn['specialty']} - ${turn['doctor']}'),
                    subtitle: Text('${turn['date']} a las ${turn['time']}'),
                    trailing: const Chip(
                      label: Text('Confirmado'),
                      backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
