import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _primaryGreen = Color(0xFF2F7F34);

  // State
  String _selectedLanguage = 'marathi';
  bool _weatherAlerts = true;
  bool _pestWarnings = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLanguageSection(),
                  const SizedBox(height: 32),
                  _buildAccountSection(),
                  const SizedBox(height: 32),
                  _buildNotificationsSection(),
                  const SizedBox(height: 32),
                  _buildAboutSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2F7F34), Color(0xFF4CA152)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 4),
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Language Selection ──
  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.translate_rounded, 'Language Selection'),
        const SizedBox(height: 14),
        _LanguageOption(
          symbol: 'म',
          title: 'Marathi (मराठी)',
          subtitle: 'Selected / निवडलेली भाषा',
          subtitleColor: _primaryGreen,
          selected: _selectedLanguage == 'marathi',
          onTap: () => setState(() => _selectedLanguage = 'marathi'),
        ),
        const SizedBox(height: 10),
        _LanguageOption(
          symbol: 'हिं',
          title: 'Hindi (हिंदी)',
          subtitle: 'हिंदी भाषा का चयन करें',
          subtitleColor: const Color(0xFF94A3B8),
          selected: _selectedLanguage == 'hindi',
          onTap: () => setState(() => _selectedLanguage = 'hindi'),
        ),
        const SizedBox(height: 10),
        _LanguageOption(
          symbol: 'En',
          title: 'English',
          subtitle: 'Use standard English app interface',
          subtitleColor: const Color(0xFF94A3B8),
          selected: _selectedLanguage == 'english',
          onTap: () => setState(() => _selectedLanguage = 'english'),
        ),
      ],
    );
  }

  // ── Account & Profile ──
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.person_rounded, 'Account & Profile'),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryGreen.withOpacity(0.10), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              _ProfileMenuItem(
                icon: Icons.badge_rounded,
                title: 'Farmer Profile',
                subtitle: 'Edit your land and crop details',
                showDivider: true,
                onTap: () {},
              ),
              _ProfileMenuItem(
                icon: Icons.payments_rounded,
                title: 'Subscription',
                subtitle: 'View your current Agri Plus plan',
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Notifications ──
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.notifications_rounded, 'Notifications'),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryGreen.withOpacity(0.10), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              _ToggleMenuItem(
                icon: Icons.cloud_rounded,
                label: 'Weather Alerts',
                value: _weatherAlerts,
                showDivider: true,
                onChanged: (v) => setState(() => _weatherAlerts = v),
              ),
              _ToggleMenuItem(
                icon: Icons.pest_control_rounded,
                label: 'Pest Warnings',
                value: _pestWarnings,
                showDivider: false,
                onChanged: (v) => setState(() => _pestWarnings = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── About ──
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.info_rounded, 'About Agri Voice'),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryGreen.withOpacity(0.10), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              // App icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2F7F34), Color(0xFF1B5E20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 12),
              const Text(
                'Agri Voice v2.4.0',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Empowering farmers through technology',
                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _AboutButton(label: 'Privacy Policy', onTap: () {}),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AboutButton(label: 'Terms of Use', onTap: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Section Title helper ──
  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: _primaryGreen, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LANGUAGE OPTION CARD
// ─────────────────────────────────────────────

class _LanguageOption extends StatelessWidget {
  final String symbol;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final bool selected;
  final VoidCallback onTap;

  static const _primaryGreen = Color(0xFF2F7F34);

  const _LanguageOption({
    required this.symbol,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _primaryGreen : _primaryGreen.withOpacity(0.20),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Language symbol badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primaryGreen.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: subtitleColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _primaryGreen : _primaryGreen.withOpacity(0.30),
                  width: 2,
                ),
                color: selected ? _primaryGreen : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.circle, color: Colors.white, size: 10)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROFILE MENU ITEM
// ─────────────────────────────────────────────

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showDivider;
  final VoidCallback onTap;

  static const _primaryGreen = Color(0xFF2F7F34);

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _primaryGreen, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 22),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: _primaryGreen.withOpacity(0.10), indent: 14, endIndent: 14),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  TOGGLE MENU ITEM
// ─────────────────────────────────────────────

class _ToggleMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  static const _primaryGreen = Color(0xFF2F7F34);

  const _ToggleMenuItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.showDivider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF94A3B8), size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.white,
                  activeTrackColor: _primaryGreen,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: _primaryGreen.withOpacity(0.10), indent: 14, endIndent: 14),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  ABOUT BUTTON
// ─────────────────────────────────────────────

class _AboutButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  static const _primaryGreen = Color(0xFF2F7F34);

  const _AboutButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _primaryGreen.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: _primaryGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}