import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // For MainScreen
import 'onboarding_screen.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);

    _simulateBiometricCheck();
  }

  void _simulateBiometricCheck() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isValidated = true);
      _controller.stop();
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        // Check SharedPreferences directly to be sure (avoids race conditions with Provider init)
        final prefs =
            await SharedPreferences.getInstance(); // Requires import shared_preferences
        final bool completed = prefs.getBool('hasCompletedOnboarding') ?? false;

        if (mounted) {
          if (completed) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isValidated ? 1.0 : _scaleAnimation.value,
                  child: Icon(
                    _isValidated ? Icons.check_circle : Icons.fingerprint,
                    size: 120,
                    color: _isValidated
                        ? Colors.greenAccent
                        : Colors.blueAccent,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              _isValidated ? 'Identidad Validada' : 'Escaneando...',
              style: TextStyle(
                color: _isValidated ? Colors.greenAccent : Colors.white,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            if (!_isValidated) ...[
              const SizedBox(height: 16),
              const SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
