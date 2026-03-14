import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/screens/profile_settings_screen.dart';
import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/favorites_screen.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/screens/language_screen.dart';

import 'package:user_app/providers/address_provider.dart';
import 'package:user_app/providers/cart_provider.dart';
import 'package:user_app/providers/locale_provider.dart';
import 'package:user_app/providers/amount_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = getUserPref<String>("name") ?? "Guest";
    final String email = getUserPref<String>("email") ?? "";
    final String photoUrl = getUserPref<String>("photoUrl") ?? "";

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          _DrawerHeader(
              name: name, email: email, photoUrl: photoUrl),

          // ── Menu items ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel("Account"),
                  _DrawerTile(
                    icon: Icons.manage_accounts_rounded,
                    label: "Profile Settings",
                    onTap: () => _push(
                        context, const ProfileSettingsScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.receipt_long_rounded,
                    label: "My Orders",
                    onTap: () =>
                        _push(context, const OrdersScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.favorite_rounded,
                    label: "Favourites",
                    onTap: () =>
                        _push(context, const FavoritesScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.location_on_rounded,
                    label: "Address Manager",
                    onTap: () =>
                        _push(context, AddressScreen()),
                  ),
                  _DrawerTile(
                    icon: Icons.language_rounded,
                    label: "Language",
                    onTap: () => _push(
                        context, const LanguageSelectionScreen()),
                  ),

                  const SizedBox(height: 8),
                  _Divider(),
                  _SectionLabel("Support"),

                  _DrawerTile(
                    icon: Icons.help_outline_rounded,
                    label: "Help & FAQ",
                    onTap: () => _showComingSoon(context),
                  ),
                  _DrawerTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: "Contact Us",
                    onTap: () => _showComingSoon(context),
                  ),

                  const SizedBox(height: 8),
                  _Divider(),
                  _SectionLabel("Legal"),

                  _DrawerTile(
                    icon: Icons.privacy_tip_outlined,
                    label: "Privacy Policy",
                    onTap: () => _showPolicy(
                      context,
                      title: "Privacy Policy",
                      icon: Icons.privacy_tip_outlined,
                    ),
                  ),
                  _DrawerTile(
                    icon: Icons.gavel_rounded,
                    label: "Terms & Conditions",
                    onTap: () => _showPolicy(
                      context,
                      title: "Terms & Conditions",
                      icon: Icons.gavel_rounded,
                    ),
                  ),
                  _DrawerTile(
                    icon: Icons.cookie_outlined,
                    label: "Cookie Policy",
                    onTap: () => _showPolicy(
                      context,
                      title: "Cookie Policy",
                      icon: Icons.cookie_outlined,
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Sign out ───────────────────────────────────────────────────
          _SignOutButton(
            onTap: () => _signOut(context),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showComingSoon(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Coming soon!")),
    );
  }

  void _showPolicy(BuildContext context,
      {required String title, required IconData icon}) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PolicySheet(title: title, icon: icon),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    Navigator.pop(context);
    await firebaseAuth.signOut();
    clearSession();
    if (!context.mounted) return;
    Provider.of<CartProvider>(context, listen: false).reset();
    Provider.of<AddressProvider>(context, listen: false).reset();
    Provider.of<AmountProvider>(context, listen: false).reset();
    Provider.of<LocaleProvider>(context, listen: false).reset();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  final String name, email, photoUrl;
  const _DrawerHeader(
      {required this.name,
      required this.email,
      required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFEF9A9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child: ClipOval(
              child: photoUrl.isNotEmpty
                  ? Image.network(photoUrl, fit: BoxFit.cover)
                  : Container(
                      color: Colors.white.withValues(alpha: 0.3),
                      child: const Icon(Icons.person_rounded,
                          size: 40, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              email,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Drawer tile ───────────────────────────────────────────────────────────────

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: Colors.redAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              trailing ??
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Divider ───────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey.shade100),
    );
  }
}

// ── Sign out button ───────────────────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 18),
              SizedBox(width: 8),
              Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Policy bottom sheet ───────────────────────────────────────────────────────

class _PolicySheet extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PolicySheet({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      color: Colors.redAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: Colors.grey.shade400),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          // Placeholder content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PolicySection(
                    title: "1. Introduction",
                    body:
                        "Welcome to Freequick. By using our app you agree to these terms. Please read them carefully before placing an order or using any of our services.",
                  ),
                  _PolicySection(
                    title: "2. Data We Collect",
                    body:
                        "We collect information you provide directly, such as your name, email address, phone number, delivery address, and payment information. We also collect usage data to improve our service.",
                  ),
                  _PolicySection(
                    title: "3. How We Use Your Data",
                    body:
                        "Your data is used to process orders, communicate order updates, personalise your experience, and improve our platform. We do not sell your personal data to third parties.",
                  ),
                  _PolicySection(
                    title: "4. Your Rights",
                    body:
                        "You have the right to access, correct, or delete your personal data at any time. You can manage your preferences in Profile Settings or contact our support team.",
                  ),
                  _PolicySection(
                    title: "5. Contact",
                    body:
                        "If you have questions about this policy, contact us at support@freequick.app.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title, body;
  const _PolicySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.6)),
        ],
      ),
    );
  }
}