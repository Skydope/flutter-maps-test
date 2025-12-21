import 'package:flutter/material.dart';
import '../main.dart'; // To access MainScreen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bienvenido a Bolívar Digital',
      'desc':
          'Tu ciudad, ahora más conectada que nunca. Accedé a todos los servicios municipales desde tu celular.',
      'image':
          'https://illustrations.popsy.co/amber/engineer.svg', // Placeholder illustration
    },
    {
      'title': 'Servicios al Instante',
      'desc':
          'Turnos médicos, pago de tasas, reclamos y más trámites sin moverte de tu casa.',
      'image': 'https://illustrations.popsy.co/amber/app-development.svg',
    },
    {
      'title': 'Participación Ciudadana',
      'desc':
          'Tu voz cuenta. Votá proyectos, reportá problemas y hacé de Bolívar una ciudad mejor.',
      'image': 'https://illustrations.popsy.co/amber/success.svg',
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
                        // We use Icons as placeholders if images fail or for simplicity
                        Icon(
                          index == 0
                              ? Icons.location_city
                              : index == 1
                              ? Icons.touch_app
                              : Icons.people,
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
                  FilledButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
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
