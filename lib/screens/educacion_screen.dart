import 'package:flutter/material.dart';

class EducacionScreen extends StatelessWidget {
  const EducacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cursos = [
      {
        'titulo': 'Programación Web Inicial',
        'duracion': '3 meses',
        'modalidad': 'Virtual',
        'color': Colors.blueAccent,
        'icon': Icons.code,
      },
      {
        'titulo': 'Taller de Arte y Pintura',
        'duracion': 'Anual',
        'modalidad': 'Presencial',
        'color': Colors.orangeAccent,
        'icon': Icons.palette,
      },
      {
        'titulo': 'Inglés Técnico',
        'duracion': '6 meses',
        'modalidad': 'Híbrido',
        'color': Colors.redAccent,
        'icon': Icons.language,
      },
      {
        'titulo': 'Robótica para Niños',
        'duracion': '4 meses',
        'modalidad': 'Presencial',
        'color': Colors.indigoAccent,
        'icon': Icons.smart_toy,
      },
      {
        'titulo': 'Marketing Digital',
        'duracion': '2 meses',
        'modalidad': 'Virtual',
        'color': Colors.purpleAccent,
        'icon': Icons.campaign,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Educación y Cultura')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Buscar cursos, talleres...',
              leading: const Icon(Icons.search),
              elevation: WidgetStateProperty.all(1),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cursos.length,
              itemBuilder: (context, index) {
                final curso = cursos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: curso['color'].withOpacity(0.2),
                      child: Icon(curso['icon'], color: curso['color']),
                    ),
                    title: Text(
                      curso['titulo'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${curso['modalidad']} • ${curso['duracion']}',
                    ),
                    trailing: FilledButton.tonal(
                      onPressed: () {
                        _showInscripcionDialog(context, curso['titulo']);
                      },
                      child: const Text('Inscribirse'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showInscripcionDialog(BuildContext context, String curso) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Inscripción a $curso'),
        content: const Text(
          '¿Deseas confirmar tu inscripción? Se te enviará el formulario completo por email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('¡Inscripción a $curso exitosa!')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
