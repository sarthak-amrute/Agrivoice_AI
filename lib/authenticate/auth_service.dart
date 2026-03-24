// ─────────────────────────────────────────────────────────────
//  AUTH SERVICE  —  Offline Authentication (no Firebase/backend)
//  Uses: shared_preferences (already in pubspec) + crypto (SHA-256)
//
//  Storage keys:
//    auth_users          → JSON list of registered users
//    auth_logged_in      → bool  (is someone logged in?)
//    auth_current_user   → String (username of logged-in user)
// ─────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── User Model ───────────────────────────────────────────────

class AuthUser {
  final String username;
  final String passwordHash; // SHA-256 hex string

  const AuthUser({required this.username, required this.passwordHash});

  Map<String, dynamic> toJson() => {
        'username': username,
        'passwordHash': passwordHash,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        username: json['username'] as String,
        passwordHash: json['passwordHash'] as String,
      );
}

// ── Auth Result ──────────────────────────────────────────────

class AuthResult {
  final bool success;
  final String? error;
  const AuthResult.ok() : success = true, error = null;
  const AuthResult.fail(this.error) : success = false;
}

// ── Auth Service ─────────────────────────────────────────────

class AuthService {
  // SharedPreferences keys
  static const _kUsers      = 'auth_users';
  static const _kLoggedIn   = 'auth_logged_in';
  static const _kCurrentUser= 'auth_current_user';

  // ── SHA-256 password hashing ─────────────────────────────
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ── Load all users from SharedPreferences ────────────────
  static Future<List<AuthUser>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUsers);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => AuthUser.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── Save all users to SharedPreferences ──────────────────
  static Future<void> _saveUsers(List<AuthUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_kUsers, encoded);
  }

  // ── Register ─────────────────────────────────────────────
  static Future<AuthResult> register({
    required String username,
    required String password,
  }) async {
    final trimmed = username.trim().toLowerCase();

    // Validation
    if (trimmed.isEmpty) return const AuthResult.fail('Username cannot be empty.');
    if (trimmed.length < 3) return const AuthResult.fail('Username must be at least 3 characters.');
    if (password.length < 6) return const AuthResult.fail('Password must be at least 6 characters.');

    final users = await _loadUsers();

    // Check duplicate
    final exists = users.any((u) => u.username == trimmed);
    if (exists) return const AuthResult.fail('Username already taken. Please choose another.');

    // Save new user
    users.add(AuthUser(username: trimmed, passwordHash: _hashPassword(password)));
    await _saveUsers(users);

    return const AuthResult.ok();
  }

  // ── Login ────────────────────────────────────────────────
  static Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    final trimmed = username.trim().toLowerCase();

    if (trimmed.isEmpty) return const AuthResult.fail('Please enter your username.');
    if (password.isEmpty) return const AuthResult.fail('Please enter your password.');

    final users = await _loadUsers();
    final hash  = _hashPassword(password);

    final match = users.where(
      (u) => u.username == trimmed && u.passwordHash == hash,
    );

    if (match.isEmpty) return const AuthResult.fail('Invalid username or password.');

    // Save session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kCurrentUser, trimmed);

    return const AuthResult.ok();
  }

  // ── Logout ───────────────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kCurrentUser);
  }

  // ── Session check ────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  // ── Get current username ─────────────────────────────────
  static Future<String?> currentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCurrentUser);
  }
}