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
import 'package:phone_form_field/phone_form_field.dart';
import "package:user_app/screens/language_screen.dart";
import 'package:user_app/widgets/unified_app_bar.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  late PhoneController _phoneController;

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

    String savedPhone = sharedPreferences!.getString("phone") ?? "";
    _phoneController = PhoneController(
      initialValue: savedPhone.isNotEmpty 
          ? PhoneNumber.parse(savedPhone) 
          : PhoneNumber.parse('+1'), // Default fallback
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
    bool isPhoneChanged = _phoneController.value.toString() != oldPhone;
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
        updateData["phone"] =_phoneController.value.toString();
        await sharedPreferences!.setString("phone", _phoneController.value.toString());
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
        backgroundColor: Colors.white,
        appBar: UnifiedAppBar(
          title: "Profile Settings",
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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

                Container(
                  margin: const EdgeInsets.all(10),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      scaffoldBackgroundColor: Colors.white,
                      appBarTheme: const AppBarTheme(
                        backgroundColor: Colors.blueAccent,
                        iconTheme: IconThemeData(color: Colors.white, size: 28),
                      ),
                    ),
                    child: PhoneFormField(
                      controller: _phoneController,
                      countrySelectorNavigator: const CountrySelectorNavigator.page(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        focusColor: Theme.of(context).primaryColor,
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(context),
                        PhoneValidator.validMobile(context),
                      ]),
                    ),
                  ),
                ),

                const Divider(height: 40, thickness: 2),

                ListTile(
                  leading: const Icon(Icons.language, color: Colors.blueAccent),
                  title: const Text("Language"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LanguageSelectionScreen()
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.add_location_alt, color: Colors.blueAccent),
                  title: const Text("Address Manager"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddressScreen()
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
