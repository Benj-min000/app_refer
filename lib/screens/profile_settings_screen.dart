import 'dart:io';
import 'package:flutter/material.dart';
import "package:user_app/global/global.dart";
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool isLoading = true;

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String? currentPhotoUrl;

  Future<void> _getImage() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        imageXFile = selectedImage;
      });
    }
  }

  void _prepareUserData() {
    _nameController = TextEditingController(
      text: sharedPreferences?.getString("name") ?? ""
    );
    _phoneController = TextEditingController(
      text: sharedPreferences?.getString("phone") ?? ""
    );
    currentPhotoUrl = sharedPreferences!.getString("photo");

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    String oldName = sharedPreferences!.getString("name") ?? "";
    String oldPhone = sharedPreferences!.getString("phone") ?? "";

    bool isNameChanged = _nameController.text.trim() != oldName;
    bool isPhoneChanged = _phoneController.text.trim() != oldPhone;
    bool isImageChanged = imageXFile != null;

    if (!isNameChanged && !isPhoneChanged && !isImageChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes detected.")),
      );
      return; 
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const LoadingDialog(message: "Updating profile..."),
    );

    try {
      String userUid = sharedPreferences!.getString("uid") ?? "";
      Map<String, dynamic> updateData = {};

      if (isImageChanged) {
        fStorage.Reference reference = fStorage.FirebaseStorage.instance
            .ref().child('users').child(userUid);
        
        fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot = await uploadTask;
        String newDownloadUrl = await taskSnapshot.ref.getDownloadURL();
        
        updateData["photo"] = newDownloadUrl;
        await sharedPreferences!.setString("photo", newDownloadUrl);
      }

      if (isNameChanged) {
        updateData["name"] = _nameController.text.trim();
        await sharedPreferences!.setString("name", _nameController.text.trim());
      }
      
      if (isPhoneChanged) {
        updateData["phone"] = _phoneController.text.trim();
        await sharedPreferences!.setString("phone", _phoneController.text.trim());
      }

      await FirebaseFirestore.instance.collection("users").doc(userUid).update(updateData);
    
      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      setState(() {
        imageXFile = null;
      });
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(context: context, builder: (c) => ErrorDialog(message: e.toString()));
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
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          title: const Text(
            "I-Eat",
            style: TextStyle(fontFamily: "Signatra", fontSize: 40),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),

        body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Material(
                        elevation: 10, // Adjust this for shadow depth
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photo")!
                          ),
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
                            backgroundColor: Colors.blueAccent,
                            radius: 20,
                            child: InkWell(
                              onTap: () async {
                                await _getImage();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.edit, 
                                  size: 22,
                                  color: Colors.white
                                ),
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

                const SizedBox(height: 15),

                CustomTextField(
                  controller: _phoneController,
                  hintText: "Phone Number",
                  data: Icons.phone,
                  isObsecure: false,
                  enabled: true,
                ),

                const Divider(height: 40),

                ListTile(
                  leading: const Icon(Icons.add_location_alt, color: Colors.blueAccent),
                  title: const Text("Address Manager"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressScreen()
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.security_rounded, color: Colors.blueAccent),
                  title: const Text("Account Security"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () { /* Navigate */ },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_active, color: Colors.blueAccent),
                  title: const Text("Notifications"),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                
                const SizedBox(height: 40),

                // Save Button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _saveUserData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
      )
    );
  }
}

// ----------