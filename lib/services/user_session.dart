import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession extends ChangeNotifier {
  String _userName = 'Juan Pérez';
  String _userDni = '12.345.678';
  String _userEmail = 'juan.perez@email.com';
  bool _hasCompletedOnboarding = false;
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  String get userName => _userName;
  String get dni => _userDni;
  String get email => _userEmail;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  List<Map<String, dynamic>> get appointments => _appointments;
  bool get isLoading => _isLoading;

  UserSession() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Juan Pérez';
    _userDni = prefs.getString('dni') ?? '12.345.678';
    _userEmail = prefs.getString('email') ?? 'juan.perez@email.com';
    _hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;

    final String? appointmentsString = prefs.getString('appointments');
    if (appointmentsString != null) {
      final List<dynamic> decoded = json.decode(appointmentsString);
      _appointments = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(
    String newName,
    String newDni,
    String newEmail,
  ) async {
    // Format DNI with dots
    final formattedDni = _formatDni(newDni);

    // IMPORTANT: Save to SharedPreferences FIRST to prevent data loss
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
    await prefs.setString('dni', formattedDni);
    await prefs.setString('email', newEmail);

    // Then update in-memory values
    _userName = newName;
    _userDni = formattedDni;
    _userEmail = newEmail;

    // Finally notify listeners to update UI
    notifyListeners();

    debugPrint('Profile saved: $_userName, $_userDni, $_userEmail');
  }

  String _formatDni(String dni) {
    // Remove all non-digits
    String cleaned = dni.replaceAll(RegExp(r'\D'), '');
    // Format with dots
    if (cleaned.isEmpty) return dni;
    try {
      // Validate it's a number but don't store it
      int.parse(cleaned);
      final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      return cleaned.replaceAllMapped(formatter, (Match m) => '${m[1]}.');
    } catch (e) {
      return dni;
    }
  }

  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
  }

  Future<void> clearData() async {
    _userName = 'Juan Pérez';
    _userDni = '12.345.678';
    _userEmail = 'juan.perez@email.com';
    _hasCompletedOnboarding = false;
    _appointments = [];

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> addAppointment(Map<String, dynamic> appointment) async {
    _appointments.insert(0, appointment); // Add to top
    notifyListeners();
    _saveAppointments();
  }

  Future<void> removeAppointment(String id) async {
    _appointments.removeWhere((app) => app['id'] == id);
    notifyListeners();
    _saveAppointments();
  }

  Future<void> _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appointments', json.encode(_appointments));
  }
}
