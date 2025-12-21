import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Recordatorio de Turno',
      'body': 'Tenés un turno médico mañana a las 09:00 hs con el Dr. García.',
      'time': 'Hace 1 hora',
      'icon': Icons.calendar_month,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Reclamo Resuelto',
      'body':
          'Tu reclamo #002 sobre recolección ha sido marcado como resuelto.',
      'time': 'Hace 3 horas',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'Alerta Meteorológica',
      'body': 'Se esperan lluvias fuertes para la tarde. Tomá precauciones.',
      'time': 'Hace 5 horas',
      'icon': Icons.cloud,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'Vencimiento de Tasas',
      'body': 'Recordá que el 10/01 vence la tasa municipal.',
      'time': 'Ayer',
      'icon': Icons.attach_money,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_check),
            tooltip: 'Marcar todas como leídas',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Todas las notificaciones marcadas como leídas',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('No tenés notificaciones nuevas'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return Dismissible(
                  key: Key(item['id']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Notificación eliminada'),
                        action: SnackBarAction(
                          label: 'Deshacer',
                          onPressed: () {
                            // Logic to undo would go here
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item['color'].withOpacity(0.1),
                        child: Icon(item['icon'], color: item['color']),
                      ),
                      title: Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(item['body']),
                          const SizedBox(height: 4),
                          Text(
                            item['time'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
