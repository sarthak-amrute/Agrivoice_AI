// ─────────────────────────────────────────────────────────────
//  AUTH GATE
//  Drop into: lib/auth/auth_gate.dart
//
//  This widget checks the session on startup.
//  • If already logged in → shows HomeWidget directly
//  • If not logged in     → shows LoginScreen
//
//  Usage: wrap your MainShell (or any home widget) with AuthGate
//  in main.dart (see integration guide).
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  /// The widget to show when the user IS logged in (your existing MainShell).
  final Widget home;

  const AuthGate({super.key, required this.home});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // null = still checking, true = logged in, false = not logged in
  bool? _loggedIn;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (mounted) setState(() => _loggedIn = loggedIn);
  }

  void _onLoginSuccess() {
    if (mounted) setState(() => _loggedIn = true);
  }

  void _onLogout() {
    if (mounted) setState(() => _loggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    // ── Still loading session ────────────────────────────────
    if (_loggedIn == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B5E20),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    // ── Logged in → show home ───────────────────────────────
    if (_loggedIn == true) {
      // We wrap the home widget with a LogoutNotifier so any
      // screen deep in the tree can trigger logout easily.
      return LogoutNotifier(onLogout: _onLogout, child: widget.home);
    }

    // ── Not logged in → show login ──────────────────────────
    return LoginScreen(onLoginSuccess: _onLoginSuccess);
  }
}

// ─────────────────────────────────────────────────────────────
//  LOGOUT NOTIFIER  —  lets any widget trigger logout
//
//  Usage from any screen:
//    LogoutNotifier.of(context).logout();
// ─────────────────────────────────────────────────────────────

class LogoutNotifier extends InheritedWidget {
  final VoidCallback onLogout;

  const LogoutNotifier({
    super.key,
    required this.onLogout,
    required super.child,
  });

  /// Call this from any screen to log the user out:
  ///   LogoutNotifier.of(context).logout();
  static LogoutNotifier? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LogoutNotifier>();

  static LogoutNotifier of(BuildContext context) {
    final notifier = maybeOf(context);
    assert(notifier != null, 'No LogoutNotifier found in widget tree.');
    return notifier!;
  }

  /// Performs logout (clears session) then triggers UI rebuild.
  Future<void> logout() async {
    await AuthService.logout();
    onLogout();
  }

  @override
  bool updateShouldNotify(LogoutNotifier old) => onLogout != old.onLogout;
}