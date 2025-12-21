import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ParticipacionScreen extends StatefulWidget {
  const ParticipacionScreen({super.key});

  @override
  State<ParticipacionScreen> createState() => _ParticipacionScreenState();
}

class _ParticipacionScreenState extends State<ParticipacionScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // Mock data for projects
  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Renovación Plaza Mitre',
      'description': 'Mejoras en juegos infantiles y luminarias LED.',
      'votes': 450,
      'hasVoted': false,
      'color': Colors.green,
      'icon': Icons.park,
    },
    {
      'title': 'Ciclovía Avenida San Martín',
      'description': 'Carril exclusivo para bicicletas de punta a punta.',
      'votes': 320,
      'hasVoted': false,
      'color': Colors.blue,
      'icon': Icons.directions_bike,
    },
    {
      'title': 'Festival de Música Local',
      'description': 'Evento gratuito mensual para bandas locales.',
      'votes': 280,
      'hasVoted': false,
      'color': Colors.purple,
      'icon': Icons.music_note,
    },
  ];

  void _vote(int index) {
    setState(() {
      if (!_projects[index]['hasVoted']) {
        _projects[index]['votes'] += 1;
        _projects[index]['hasVoted'] = true;
        _confettiController.play();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Gracias por tu voto en "${_projects[index]['title']}"!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Participación Ciudadana')),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              const Text(
                'Proyectos en Votación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                _projects.length,
                (index) => _buildProjectCard(index),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Colors.blueAccent.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.how_to_vote, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tu voz cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Votá los proyectos que querés ver en tu ciudad. El presupuesto participativo lo construimos entre todos.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(int index) {
    final project = _projects[index];
    final totalVotes = 1000; // Mock total for percentage
    final percentage = project['votes'] / totalVotes;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: project['color'].withOpacity(0.1),
                  child: Icon(project['icon'], color: project['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(project['description']),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      color: project['color'],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${project['votes']} votos',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: project['hasVoted']
                  ? OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check),
                      label: const Text('Ya votaste'),
                    )
                  : FilledButton(
                      onPressed: () => _vote(index),
                      child: const Text('Votar'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
