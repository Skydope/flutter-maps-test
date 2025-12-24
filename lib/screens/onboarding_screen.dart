import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // To access MainScreen
import '../services/user_session.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bienvenido a Bolívar Digital',
      'desc':
          'Tu ciudad, ahora más conectada que nunca. Accedé a todos los servicios municipales desde tu celular.',
    },
    {
      'title': 'Servicios al Instante',
      'desc':
          'Turnos médicos, pago de tasas, reclamos y más trámites sin moverte de tu casa.',
    },
    {
      'title': 'Completá tus datos',
      'desc': 'Ingresá tu nombre y DNI para personalizar tu experiencia.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          index == 0
                              ? Icons.location_city
                              : index == 1
                              ? Icons.touch_app
                              : Icons.person_pin,
                          size: 150,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _pages[index]['title']!,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]['desc']!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),

                        // Formulario en la última pantalla
                        if (index == 2) ...[
                          const SizedBox(height: 32),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre Completo',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _dniController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'DNI',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.badge),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Puntos indicadores
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  // Botón Siguiente / Comenzar
                  FilledButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        // Validate and Save Data
                        if (_nameController.text.isNotEmpty &&
                            _dniController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty) {
                          context.read<UserSession>().updateProfile(
                            _nameController.text,
                            _dniController.text,
                            _emailController.text,
                          );

                          context.read<UserSession>().completeOnboarding();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MainScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor completá todos los datos',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Comenzar'
                          : 'Siguiente',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
