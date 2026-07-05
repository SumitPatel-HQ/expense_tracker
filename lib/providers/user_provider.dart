import 'package:expense_tracker/database/user_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserProfile? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  UserProfile? get currentUser => _currentUser;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (_isLoggedIn) {
      _currentUser = await UserDatabase.instance.fetchProfile();
      if (_currentUser == null) {
        _isLoggedIn = false;
        await prefs.setBool('isLoggedIn', false);
      }
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> createOrLogin(UserProfile profile) async {
    await UserDatabase.instance.saveProfile(profile);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    _currentUser = profile;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
