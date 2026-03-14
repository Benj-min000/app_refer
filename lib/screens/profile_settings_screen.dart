import 'dart:io';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/widgets/error_dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:phone_form_field/phone_form_field.dart';
import 'package:user_app/screens/language_screen.dart';
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

  bool isLoading = true;
  File? _newPhoto;
  String? currentPhotoUrl;

  void _prepareUserData() {
    _nameController = TextEditingController(
      text: getUserPref<String>("name") ?? "",
    );

    final savedPhone = getUserPref<String>("phone") ?? "";
    _phoneController = PhoneController(
      initialValue: savedPhone.isNotEmpty
          ? PhoneNumber.parse(savedPhone)
          : PhoneNumber.parse('+1'),
    );

    currentPhotoUrl = getUserPref<String>("photoUrl");

    setState(() => isLoading = false);
  }

  Future<void> _getImage() async {
    final file = await ImagePickerService.pickAndCrop(context);
    if (file != null) setState(() => _newPhoto = file);
  }

  Future<void> _saveUserData() async {
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
        final fStorage.Reference ref = fStorage.FirebaseStorage.instance
            .ref()
            .child('users')
            .child(currentUid!);

        final fStorage.TaskSnapshot snap = await ref.putFile(_newPhoto!);
        final String newUrl = await snap.ref.getDownloadURL();

        updateData["photoUrl"] = newUrl;
        await saveUserPref<String>("photoUrl", newUrl);
        setState(() {
          currentPhotoUrl = newUrl;
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

  @override
  void initState() {
    super.initState();
    _prepareUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        final focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
          focus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: UnifiedAppBar(
          title: "Profile Settings",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // -- Avatar ---------------------------------------------
                    Center(
                      child: Stack(
                        children: [
                          Material(
                            elevation: 10,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _newPhoto != null
                                  ? FileImage(_newPhoto!) as ImageProvider
                                  : (currentPhotoUrl != null &&
                                          currentPhotoUrl!.isNotEmpty
                                      ? NetworkImage(currentPhotoUrl!)
                                      : null),
                              child: (_newPhoto == null &&
                                      (currentPhotoUrl == null ||
                                          currentPhotoUrl!.isEmpty))
                                  ? const Icon(Icons.person_rounded,
                                      size: 60, color: Colors.white)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Material(
                              elevation: 6,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              shadowColor: Colors.black54,
                              child: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius: 20,
                                child: InkWell(
                                  onTap: _getImage,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.edit_rounded,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomTextField(
                      controller: _nameController,
                      hintText: "Full Name",
                      data: Icons.person,
                      isObsecure: false,
                      enabled: true,
                    ),

                    CustomPhoneField(
                      controller: _phoneController,
                      label: "Phone Number",
                    ),

                    const Divider(height: 40, thickness: 1),

                    // -- Settings tiles -------------------------------------
                    ListTile(
                      leading:
                          const Icon(Icons.language, color: Colors.redAccent),
                      title: const Text("Language"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen()),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.add_location_alt,
                          color: Colors.redAccent),
                      title: const Text("Address Manager"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddressScreen()),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.security_rounded,
                          color: Colors.redAccent),
                      title: const Text("Account Security"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),

                    ListTile(
                      leading: const Icon(Icons.notifications_active,
                          color: Colors.redAccent),
                      title: const Text("Notifications"),
                      trailing: Switch(
                          value: true,
                          onChanged: (v) {},
                          activeThumbColor: Colors.redAccent),
                    ),

                    const SizedBox(height: 40),

                    // -- Save button ----------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _saveUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
