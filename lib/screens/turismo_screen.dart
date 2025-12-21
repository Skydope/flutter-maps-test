import 'package:flutter/material.dart';

class TurismoScreen extends StatelessWidget {
  const TurismoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Descubrí Bolívar'),
              background: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Bolivar_-_Buenos_Aires_%28plza_Alsina%29.jpg/1200px-Bolivar_-_Buenos_Aires_%28plza_Alsina%29.jpg', // Placeholder image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.orangeAccent,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Lugares Imperdibles',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              _buildTurismoItem(
                context,
                'Parque Las Acollaradas',
                'El pulmón verde de la ciudad. Ideal para deportes y mate.',
                Icons.park,
                Colors.green,
              ),
              _buildTurismoItem(
                context,
                'Cine Avenida',
                'Edificio histórico restaurado con la mejor cartelera.',
                Icons.movie,
                Colors.red,
              ),
              _buildTurismoItem(
                context,
                'Museo Florentino Ameghino',
                'Historia, paleontología y ciencias naturales.',
                Icons.museum,
                Colors.brown,
              ),
              _buildTurismoItem(
                context,
                'Centro Cívico',
                'El corazón administrativo y social de la ciudad.',
                Icons.location_city,
                Colors.blue,
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abriendo mapa turístico...')),
          );
        },
        label: const Text('Ver Mapa'),
        icon: const Icon(Icons.map),
      ),
    );
  }

  Widget _buildTurismoItem(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(child: Icon(icon, size: 60, color: color)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(desc, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text('Ver más detalles'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
