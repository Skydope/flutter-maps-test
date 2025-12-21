import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession extends ChangeNotifier {
  String _userName = 'Juan Pérez';
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  String get userName => _userName;
  List<Map<String, dynamic>> get appointments => _appointments;
  bool get isLoading => _isLoading;

  UserSession() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Juan Pérez';

    final String? appointmentsString = prefs.getString('appointments');
    if (appointmentsString != null) {
      final List<dynamic> decoded = json.decode(appointmentsString);
      _appointments = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(String newName) async {
    _userName = newName;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
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
