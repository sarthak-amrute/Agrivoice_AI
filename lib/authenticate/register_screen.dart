// ─────────────────────────────────────────────────────────────
//  REGISTER SCREEN
//  Drop into: lib/auth/register_screen.dart
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  /// Called after successful registration + auto-login.
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _green      = Color(0xFF2F7F34);
  static const _darkGreen  = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);

  final _usernameCtrl        = TextEditingController();
  final _passwordCtrl        = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey             = GlobalKey<FormState>();

  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;
  bool _loading                = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // ── Register + auto-login handler ─────────────────────────
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() { _loading = true; _errorMessage = null; });

    // 1. Register
    final registerResult = await AuthService.register(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    if (!registerResult.success) {
      setState(() { _loading = false; _errorMessage = registerResult.error; });
      return;
    }

    // 2. Auto-login after successful registration
    final loginResult = await AuthService.login(
      username: _usernameCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (loginResult.success) {
      widget.onRegisterSuccess();
    } else {
      // Registered but login failed — go back to login screen
      if (mounted) Navigator.pop(context);
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
                const SizedBox(height: 32),
                _buildHeader(context),
                const SizedBox(height: 28),
                _buildCard(),
                const SizedBox(height: 24),
                _buildLoginLink(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Column(children: [
      // Back button + logo row
      Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 22),
          ),
        ),
        const Spacer(),
        Container(
          width: 48, height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Colors.white,
          ),
          child: const Icon(Icons.eco_rounded, color: _green, size: 28),
        ),
        const Spacer(),
        const SizedBox(width: 40), // balance
      ]),
      const SizedBox(height: 20),
      const Text('Create Account',
          style: TextStyle(color: Colors.white, fontSize: 28,
              fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      const SizedBox(height: 4),
      Text('Join Agri Voice — farm smarter 🌱',
          style: TextStyle(color: Colors.white.withOpacity(0.75),
              fontSize: 14, fontWeight: FontWeight.w500)),
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
          const Text('New Account 🧑‍🌾',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text('Fill in the details below to get started',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const SizedBox(height: 24),

          // Error banner
          if (_errorMessage != null) ...[
            _buildErrorBanner(_errorMessage!),
            const SizedBox(height: 16),
          ],

          // ── Username ──
          _buildFieldLabel('Username'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _usernameCtrl,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Username is required';
              if (v.trim().length < 3) return 'At least 3 characters required';
              if (v.trim().contains(' ')) return 'No spaces allowed in username';
              return null;
            },
            decoration: _inputDecoration(
              hint: 'e.g. rajesh_kumar',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),

          // ── Password ──
          _buildFieldLabel('Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Minimum 6 characters required';
              return null;
            },
            decoration: _inputDecoration(
              hint: 'At least 6 characters',
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
          const SizedBox(height: 16),

          // ── Confirm Password ──
          _buildFieldLabel('Confirm Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _confirmPasswordCtrl,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleRegister(),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _passwordCtrl.text) return 'Passwords do not match';
              return null;
            },
            decoration: _inputDecoration(
              hint: 'Re-enter password',
              icon: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: const Color(0xFF94A3B8), size: 20,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Password hint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _green.withOpacity(0.20)),
            ),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, color: _green, size: 14),
              SizedBox(width: 6),
              Expanded(child: Text(
                'Password is hashed locally — your data never leaves your device.',
                style: TextStyle(color: _green, fontSize: 11,
                    fontWeight: FontWeight.w500),
              )),
            ]),
          ),
          const SizedBox(height: 24),

          // Register button
          SizedBox(
            width: double.infinity, height: 54,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleRegister,
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
                  : const Text('Create Account',
                      style: TextStyle(color: Colors.white, fontSize: 16,
                          fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Login link ────────────────────────────────────────────
  Widget _buildLoginLink() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Already have an account? ',
          style: TextStyle(color: Colors.white.withOpacity(0.80), fontSize: 14)),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Text('Sign in',
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