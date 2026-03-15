import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/providers/theme_provider.dart';
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/widgets/error_dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:phone_form_field/phone_form_field.dart';
import 'package:user_app/widgets/custom_phone_field.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/services/image_picker_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  PhoneController? _phoneController;

  bool _isLoading = true;
  final bool _isSaving = false;
  File? _newPhoto;
  String? _currentPhotoUrl;

  //  Notification prefs
  bool _notifOrderStatus = true;
  bool _notifPromotions = true;
  bool _notifNearby = true;
  bool _notifAppNews = true;

  //  App prefs
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _nameController =
        TextEditingController(text: getUserPref<String>("name") ?? "");

    final savedPhone = getUserPref<String>("phone") ?? "";
    _phoneController = PhoneController(
      initialValue: savedPhone.isNotEmpty
          ? PhoneNumber.parse(savedPhone)
          : PhoneNumber.parse('+48'),
    );

    _currentPhotoUrl = getUserPref<String>("photoUrl");
    _notifOrderStatus = getUserPref<bool>("notif_order_status") ?? true;
    _notifPromotions = getUserPref<bool>("notif_promotions") ?? true;
    _notifNearby = getUserPref<bool>("notif_nearby") ?? true;
    _notifAppNews = getUserPref<bool>("notif_app_news") ?? true;
    _darkMode = getUserPref<bool>("dark_mode") ?? false;

    setState(() => _isLoading = false);
  }

  //  Profile save

  Future<void> _saveProfile() async {
    final oldName = getUserPref<String>("name") ?? "";
    final oldPhone = getUserPref<String>("phone") ?? "";

    final isNameChanged = _nameController.text.trim() != oldName;
    final isPhoneChanged = _phoneController?.value.toString() != oldPhone;
    final isImageChanged = _newPhoto != null;

    if (!isNameChanged && !isPhoneChanged && !isImageChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes detected.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: "Updating profile..."),
    );

    try {
      final Map<String, dynamic> updateData = {};

      if (isImageChanged) {
        final ref = fStorage.FirebaseStorage.instance
            .ref()
            .child('users')
            .child(currentUid!);
        final snap = await ref.putFile(_newPhoto!);
        final newUrl = await snap.ref.getDownloadURL();
        updateData["photoUrl"] = newUrl;
        await saveUserPref<String>("photoUrl", newUrl);
        setState(() {
          _currentPhotoUrl = newUrl;
          _newPhoto = null;
        });
      }

      if (isNameChanged) {
        updateData["name"] = _nameController.text.trim();
        await saveUserPref<String>("name", _nameController.text.trim());
      }

      if (isPhoneChanged) {
        updateData["phone"] = _phoneController?.value.toString();
        await saveUserPref<String>("phone", _phoneController!.value.toString());
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .update(updateData);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
          context: context, builder: (_) => ErrorDialog(message: e.toString()));
    }
  }

  //  Notification prefs
  // Saves to SharedPreferences locally and mirrors to Firestore under
  // users/{uid}.prefs so the notification bell widget can filter by source.
  //
  // In your notification_bell.dart / notifications_screen.dart, filter
  // documents based on these prefs. Example:
  //   if source == 'order' && prefs.notif_order_status == false → skip
  //   if source == 'admin' && prefs.notif_promotions == false → skip

  Future<void> _saveNotifPref(String key, bool value) async {
    await saveUserPref<bool>(key, value);
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .update({"prefs.$key": value});
    } catch (_) {
      // Non-fatal — local pref still saved
    }
  }

  //  Dark mode

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _darkMode = value);
    await saveUserPref<bool>("dark_mode", value);
    if (!mounted) return;
    Provider.of<ThemeProvider>(context, listen: false)
        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  //  Build

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6FB),
        appBar: UnifiedAppBar(
          title: "Profile Settings",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.redAccent))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Avatar
                    _buildAvatar(),
                    const SizedBox(height: 28),

                    //  Personal info
                    _SectionLabel("Personal Information"),
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Full Name",
                            data: Icons.person_rounded,
                            isObsecure: false,
                            enabled: true,
                          ),
                          CustomPhoneField(
                            controller: _phoneController,
                            label: "Phone Number",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text("Save Changes",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),

                    const SizedBox(height: 28),

                    //  Notifications
                    _SectionLabel("Notifications"),
                    const SizedBox(height: 4),
                    Text(
                      "Choose which notifications you receive",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        children: [
                          _NotifTile(
                            icon: Icons.local_shipping_rounded,
                            label: "Order Status Updates",
                            subtitle: "Notified when your order status changes",
                            value: _notifOrderStatus,
                            onChanged: (v) async {
                              setState(() => _notifOrderStatus = v);
                              await _saveNotifPref("notif_order_status", v);
                            },
                          ),
                          _Divider(),
                          _NotifTile(
                            icon: Icons.local_offer_rounded,
                            label: "Promotions & Offers",
                            subtitle: "Discounts and deals from restaurants",
                            value: _notifPromotions,
                            onChanged: (v) async {
                              setState(() => _notifPromotions = v);
                              await _saveNotifPref("notif_promotions", v);
                            },
                          ),
                          _Divider(),
                          _NotifTile(
                            icon: Icons.storefront_rounded,
                            label: "New Restaurants Nearby",
                            subtitle:
                                "When a new restaurant opens in your area",
                            value: _notifNearby,
                            onChanged: (v) async {
                              setState(() => _notifNearby = v);
                              await _saveNotifPref("notif_nearby", v);
                            },
                          ),
                          _Divider(),
                          _NotifTile(
                            icon: Icons.campaign_rounded,
                            label: "App News & Updates",
                            subtitle: "Feature announcements and app news",
                            value: _notifAppNews,
                            onChanged: (v) async {
                              setState(() => _notifAppNews = v);
                              await _saveNotifPref("notif_app_news", v);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    //  Appearance
                    _SectionLabel("Appearance"),
                    const SizedBox(height: 12),
                    _Card(
                      child: _PrefTile(
                        icon: Icons.dark_mode_rounded,
                        label: "Dark Mode",
                        subtitle: "Switch to dark theme",
                        trailing: Switch(
                          value: _darkMode,
                          onChanged: _toggleDarkMode,
                          activeColor: Colors.redAccent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    //  Account
                    _SectionLabel("Account"),
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        children: [
                          _PrefTile(
                            icon: Icons.security_rounded,
                            label: "Account Security",
                            subtitle: "Change password, 2FA settings",
                            onTap: () => _showComingSoon("Account Security"),
                          ),
                          _Divider(),
                          _PrefTile(
                            icon: Icons.delete_outline_rounded,
                            label: "Delete Account",
                            subtitle:
                                "Permanently remove your account and data",
                            iconColor: Colors.redAccent,
                            labelColor: Colors.redAccent,
                            onTap: _showDeleteDialog,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //  Avatar

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _newPhoto != null
                  ? FileImage(_newPhoto!) as ImageProvider
                  : (_currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty
                      ? NetworkImage(_currentPhotoUrl!)
                      : null),
              child: (_newPhoto == null &&
                      (_currentPhotoUrl == null || _currentPhotoUrl!.isEmpty))
                  ? const Icon(Icons.person_rounded,
                      size: 56, color: Colors.white)
                  : null,
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: GestureDetector(
              onTap: () async {
                final file = await ImagePickerService.pickAndCrop(context);
                if (file != null) setState(() => _newPhoto = file);
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Helpers

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature — coming soon!")),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Account",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text(
            "This will permanently delete your account and all your data. This cannot be undone.",
            style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

//  Shared sub-widgets

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87));
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: Colors.grey.shade100);
}

class _NotifTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: value
                  ? Colors.redAccent.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                size: 18,
                color: value ? Colors.redAccent : Colors.grey.shade400),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: value ? Colors.black87 : Colors.grey.shade500)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                        height: 1.3)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.redAccent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _PrefTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _PrefTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.redAccent).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor ?? Colors.redAccent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: labelColor ?? Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
