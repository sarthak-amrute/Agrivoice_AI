// ─────────────────────────────────────────────────────────────
//  LOGIN SCREEN
//  Drop into: lib/auth/login_screen.dart
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  /// Called when login succeeds — navigate to your home screen here.
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _green      = Color(0xFF2F7F34);
  static const _darkGreen  = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _loading         = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Login handler ─────────────────────────────────────────
  Future<void> _handleLogin() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() { _loading = true; _errorMessage = null; });

    final result = await AuthService.login(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      widget.onLoginSuccess();
    } else {
      setState(() => _errorMessage = result.error);
    }
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_darkGreen, _lightGreen],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildCard(),
                const SizedBox(height: 24),
                _buildRegisterLink(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo ──────────────────────────────────────────────────
  Widget _buildLogo() {
    return Column(children: [
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20, offset: const Offset(0, 6),
          )],
        ),
        child: const Icon(Icons.eco_rounded, color: _green, size: 46),
      ),
      const SizedBox(height: 16),
      const Text('Agri Voice',
          style: TextStyle(color: Colors.white, fontSize: 30,
              fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      const SizedBox(height: 4),
      Text('Sign in to continue',
          style: TextStyle(color: Colors.white.withOpacity(0.75),
              fontSize: 15, fontWeight: FontWeight.w500)),
    ]);
  }

  // ── Card ──────────────────────────────────────────────────
  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 30, offset: const Offset(0, 10),
        )],
      ),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          const Text('Welcome Back 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text('Enter your credentials to access your farm',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const SizedBox(height: 28),

          // Error banner
          if (_errorMessage != null) ...[
            _buildErrorBanner(_errorMessage!),
            const SizedBox(height: 16),
          ],

          // Username field
          _buildFieldLabel('Username'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _usernameCtrl,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter your username';
              return null;
            },
            decoration: _inputDecoration(
              hint: 'e.g. rajesh_kumar',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),

          // Password field
          _buildFieldLabel('Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your password';
              return null;
            },
            decoration: _inputDecoration(
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: const Color(0xFF94A3B8), size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Login button
          SizedBox(
            width: double.infinity, height: 54,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                disabledBackgroundColor: _green.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _loading
                  ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : const Text('Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 16,
                          fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Register link ─────────────────────────────────────────
  Widget _buildRegisterLink() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Don't have an account? ",
          style: TextStyle(color: Colors.white.withOpacity(0.80), fontSize: 14)),
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterScreen(
              onRegisterSuccess: widget.onLoginSuccess,
            ),
          ),
        ),
        child: const Text('Create one',
            style: TextStyle(color: Colors.white,
                fontSize: 14, fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white)),
      ),
    ]);
  }

  // ── Helpers ───────────────────────────────────────────────
  Widget _buildFieldLabel(String label) => Text(label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: Color(0xFF374151)));

  Widget _buildErrorBanner(String message) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.red.shade200),
    ),
    child: Row(children: [
      Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(message,
          style: TextStyle(color: Colors.red.shade700,
              fontSize: 13, fontWeight: FontWeight.w500))),
    ]),
  );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _green, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2)),
      );
}