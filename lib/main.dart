import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'screens/turnos_screen.dart';
import 'screens/educacion_screen.dart';
import 'screens/turismo_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/chatbot_screen.dart';
import 'widgets/weather_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bolívar Digital 2030',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// 🏠 Pantalla Principal con Navegación
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ServiciosScreen(),
    const ReclamosScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },
        child: const Icon(Icons.support_agent),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_outlined),
            selectedIcon: Icon(Icons.apps),
            label: 'Servicios',
          ),
          NavigationDestination(
            icon: Icon(Icons.report_problem_outlined),
            selectedIcon: Icon(Icons.report_problem),
            label: 'Reclamos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// 🏠 Pantalla de Inicio
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Bolívar Digital 2030'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.location_city,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner de bienvenida
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.waving_hand, size: 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Bienvenido, Juan!',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text('Tu ciudad más conectada que nunca'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const WeatherWidget(),

                  const SizedBox(height: 24),

                  Text(
                    'Accesos Rápidos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Grid de accesos rápidos
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _QuickAccessCard(
                        icon: Icons.medical_services,
                        title: 'Turnos Médicos',
                        color: Colors.red.shade400,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TurnosScreen(),
                            ),
                          );
                        },
                      ),
                      _QuickAccessCard(
                        icon: Icons.school,
                        title: 'Educación',
                        color: Colors.blue.shade400,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EducacionScreen(),
                            ),
                          );
                        },
                      ),
                      _QuickAccessCard(
                        icon: Icons.map,
                        title: 'Negocios',
                        color: Colors.green.shade400,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NegociosMapScreen(),
                            ),
                          );
                        },
                      ),
                      _QuickAccessCard(
                        icon: Icons.tour,
                        title: 'Turismo',
                        color: Colors.orange.shade400,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TurismoScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Noticias y Eventos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Noticias
                  _NewsCard(
                    title: 'Nueva red de WiFi pública',
                    subtitle: 'Disponible en Plaza Mitre y espacios públicos',
                    icon: Icons.wifi,
                    date: 'Hace 2 días',
                  ),

                  const SizedBox(height: 12),

                  _NewsCard(
                    title: 'Campaña de vacunación',
                    subtitle: 'Inscripción abierta para todas las edades',
                    icon: Icons.vaccines,
                    date: 'Hace 5 días',
                  ),

                  const SizedBox(height: 12),

                  _NewsCard(
                    title: 'Festival de la Cultura',
                    subtitle: 'Este fin de semana en el Centro Cultural',
                    icon: Icons.celebration,
                    date: 'Hace 1 semana',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String date;

  const _NewsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(date, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}

// 🗺️ Pantalla de Mapa de Negocios
class NegociosMapScreen extends StatefulWidget {
  const NegociosMapScreen({super.key});

  @override
  State<NegociosMapScreen> createState() => _NegociosMapScreenState();
}

class _NegociosMapScreenState extends State<NegociosMapScreen> {
  final MapController mapController = MapController();

  static const LatLng plazaMitre = LatLng(
    -36.23030544196618,
    -61.113839650414725,
  );

  final List<Map<String, dynamic>> negocios = [
    {
      'nombre': 'Café Central',
      'categoria': 'Gastronomía',
      'ubicacion': const LatLng(-36.23030, -61.11380),
      'descripcion': 'Cafetería y panadería artesanal',
      'horario': '8:00 - 20:00',
    },
    {
      'nombre': 'Farmacia del Pueblo',
      'categoria': 'Salud',
      'ubicacion': const LatLng(-36.23050, -61.11400),
      'descripcion': 'Farmacia con atención 24hs',
      'horario': '24 horas',
    },
    {
      'nombre': 'Supermercado La Economía',
      'categoria': 'Supermercado',
      'ubicacion': const LatLng(-36.23000, -61.11360),
      'descripcion': 'Supermercado de barrio',
      'horario': '9:00 - 21:00',
    },
  ];

  Map<String, dynamic>? negocioSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Negocios Locales'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: plazaMitre,
              initialZoom: 16,
              maxZoom: 50,
              minZoom: 3,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.bolivar_digital',
              ),
              MarkerLayer(
                markers: negocios.map((negocio) {
                  return Marker(
                    point: negocio['ubicacion'],
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          negocioSeleccionado = negocio;
                        });
                      },
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          if (negocioSeleccionado != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              negocioSeleccionado!['nombre'],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                negocioSeleccionado = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Chip(label: Text(negocioSeleccionado!['categoria'])),
                      const SizedBox(height: 8),
                      Text(negocioSeleccionado!['descripcion']),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(negocioSeleccionado!['horario']),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 📱 Pantalla de Servicios
class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios Municipales'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ServicioCategory(
            title: 'Trámites y Gestiones',
            icon: Icons.description,
            color: Colors.blue,
            items: const [
              'Certificados digitales',
              'Constancias de domicilio',
              'Licencias de conducir',
              'Habilitaciones comerciales',
            ],
          ),

          const SizedBox(height: 16),

          _ServicioCategory(
            title: 'Salud',
            icon: Icons.local_hospital,
            color: Colors.red,
            items: const [
              'Turnos médicos online',
              'Campañas de vacunación',
              'Historial de consultas',
              'Farmacias de turno',
            ],
          ),

          const SizedBox(height: 16),

          _ServicioCategory(
            title: 'Educación',
            icon: Icons.school,
            color: Colors.indigo,
            items: const [
              'Inscripción escolar',
              'Calendario académico',
              'Cursos y capacitaciones',
              'Becas estudiantiles',
            ],
          ),

          const SizedBox(height: 16),

          _ServicioCategory(
            title: 'Seguridad',
            icon: Icons.security,
            color: Colors.orange,
            items: const [
              'Botón antipánico',
              'Alertas comunitarias',
              'Denuncia vecinal',
              'Mapa de seguridad',
            ],
          ),

          const SizedBox(height: 16),

          _ServicioCategory(
            title: 'Turismo y Cultura',
            icon: Icons.museum,
            color: Colors.purple,
            items: const [
              'Agenda de eventos',
              'Rutas turísticas',
              'Museos y patrimonio',
              'Guía de la ciudad',
            ],
          ),

          const SizedBox(height: 16),

          _ServicioCategory(
            title: 'Comercio Local',
            icon: Icons.store,
            color: Colors.green,
            items: const [
              'Directorio de comercios',
              'Emprendedores locales',
              'Habilitaciones sanitarias',
              'Ferias y mercados',
            ],
          ),
        ],
      ),
    );
  }
}

class _ServicioCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _ServicioCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: items.map((item) {
          return ListTile(
            leading: const Icon(Icons.arrow_right, size: 20),
            title: Text(item),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceDetailScreen(title: item),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

// 📢 Pantalla de Reclamos
class ReclamosScreen extends StatefulWidget {
  const ReclamosScreen({super.key});

  @override
  State<ReclamosScreen> createState() => _ReclamosScreenState();
}

class _ReclamosScreenState extends State<ReclamosScreen> {
  final List<Map<String, dynamic>> reclamos = [
    {
      'id': '#001',
      'tipo': 'Alumbrado',
      'descripcion': 'Farol sin luz en Av. San Martín 123',
      'estado': 'En proceso',
      'fecha': '15/12/2025',
      'icon': Icons.lightbulb_outline,
      'color': Colors.orange,
    },
    {
      'id': '#002',
      'tipo': 'Recolección',
      'descripcion': 'Basura sin recoger hace 3 días',
      'estado': 'Resuelto',
      'fecha': '10/12/2025',
      'icon': Icons.delete_outline,
      'color': Colors.green,
    },
    {
      'id': '#003',
      'tipo': 'Calles',
      'descripcion': 'Bache grande en calle Mitre',
      'estado': 'Pendiente',
      'fecha': '18/12/2025',
      'icon': Icons.construction,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reclamos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Estadísticas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _EstadisticaCard(valor: '3', label: 'Total', icon: Icons.list),
                _EstadisticaCard(
                  valor: '1',
                  label: 'En Proceso',
                  icon: Icons.pending,
                ),
                _EstadisticaCard(
                  valor: '1',
                  label: 'Resueltos',
                  icon: Icons.check_circle,
                ),
              ],
            ),
          ),

          // Lista de reclamos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reclamos.length,
              itemBuilder: (context, index) {
                final reclamo = reclamos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Detalle del Reclamo ${reclamo['id']}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo: ${reclamo['tipo']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Descripción: ${reclamo['descripcion']}'),
                              const SizedBox(height: 8),
                              Text('Estado: ${reclamo['estado']}'),
                              const SizedBox(height: 16),
                              const Text(
                                'Seguimiento:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text('• Reclamo recibido'),
                              if (reclamo['estado'] != 'Pendiente')
                                const Text(
                                  '• Derivado al área correspondiente',
                                ),
                              if (reclamo['estado'] == 'Resuelto')
                                const Text('• Solucionado con éxito'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: reclamo['color'].withOpacity(0.2),
                      child: Icon(reclamo['icon'], color: reclamo['color']),
                    ),
                    title: Text(
                      reclamo['tipo'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(reclamo['descripcion']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              reclamo['fecha'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              reclamo['id'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        reclamo['estado'],
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getEstadoColor(reclamo['estado']),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mostrarFormularioReclamo(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Reclamo'),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Resuelto':
        return Colors.green.shade100;
      case 'En proceso':
        return Colors.orange.shade100;
      case 'Pendiente':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _mostrarFormularioReclamo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Nuevo Reclamo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de reclamo',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'alumbrado',
                      child: Text('Alumbrado'),
                    ),
                    DropdownMenuItem(
                      value: 'recoleccion',
                      child: Text('Recolección'),
                    ),
                    DropdownMenuItem(value: 'calles', child: Text('Calles')),
                    DropdownMenuItem(value: 'otros', child: Text('Otros')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    hintText: 'Describe el problema...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Ubicación',
                    border: OutlineInputBorder(),
                    hintText: 'Dirección o ubicación',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      reclamos.insert(0, {
                        'id':
                            '#${(reclamos.length + 1).toString().padLeft(3, '0')}',
                        'tipo': 'Varios',
                        'descripcion': 'Reclamo generado recientemente...',
                        'estado': 'Pendiente',
                        'fecha':
                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        'icon': Icons.report_problem,
                        'color': Colors.blueGrey,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reclamo enviado correctamente'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Enviar Reclamo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EstadisticaCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;

  const _EstadisticaCard({
    required this.valor,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          valor,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

// 👤 Pantalla de Perfil
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Juan Pérez',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'DNI: 12.345.678',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'juan.perez@email.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Estadísticas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '15',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const Text('Trámites'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '3',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const Text('Reclamos'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '8',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const Text('Turnos'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Opciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _ProfileOption(
                    icon: Icons.person,
                    title: 'Mis Datos',
                    subtitle: 'Información personal',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceDetailScreen(
                          title: 'Mis Datos',
                          icon: Icons.person,
                        ),
                      ),
                    ),
                  ),
                  _ProfileOption(
                    icon: Icons.history,
                    title: 'Historial',
                    subtitle: 'Trámites y servicios realizados',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceDetailScreen(
                          title: 'Historial',
                          icon: Icons.history,
                        ),
                      ),
                    ),
                  ),
                  _ProfileOption(
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    subtitle: 'Configurar alertas',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceDetailScreen(
                          title: 'Notificaciones',
                          icon: Icons.notifications,
                        ),
                      ),
                    ),
                  ),
                  _ProfileOption(
                    icon: Icons.favorite,
                    title: 'Favoritos',
                    subtitle: 'Servicios guardados',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceDetailScreen(
                          title: 'Favoritos',
                          icon: Icons.favorite,
                        ),
                      ),
                    ),
                  ),
                  _ProfileOption(
                    icon: Icons.help,
                    title: 'Ayuda',
                    subtitle: 'Centro de soporte',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ServiceDetailScreen(
                          title: 'Ayuda',
                          icon: Icons.help,
                        ),
                      ),
                    ),
                  ),
                  _ProfileOption(
                    icon: Icons.info,
                    title: 'Acerca de',
                    subtitle: 'Bolívar Digital 2030 v1.0',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Bolívar Digital 2030',
                        applicationVersion: '1.0.0 MVP',
                        applicationIcon: const Icon(
                          Icons.location_city,
                          size: 48,
                        ),
                        children: const [
                          Text('Ciudad Inteligente - Transformación Digital'),
                          SizedBox(height: 8),
                          Text('San Carlos de Bolívar, Buenos Aires'),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Cerrar Sesión'),
                            content: const Text(
                              '¿Estás seguro que deseas salir?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancelar'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Salir'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar Sesión'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
