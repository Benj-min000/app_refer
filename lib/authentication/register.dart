import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/providers/cart_provider.dart';

import 'package:user_app/services/image_picker_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firestorage;
import 'package:user_app/widgets/auth_button.dart';

import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/widgets/error_dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:user_app/widgets/custom_phone_field.dart';
import 'package:user_app/widgets/custom_password_field.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/extensions/context_translate_ext.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmePasswordController =
      TextEditingController();
  late final PhoneController _phoneController;

  File? _croppedImage;
  String downloadUrl = "";

  @override
  void initState() {
    super.initState();
    _phoneController = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.PL, nsn: ''),
    );
  }

  Future<void> _getImage() async {
    final file = await ImagePickerService.pickAndCrop(context);
    if (file != null) setState(() => _croppedImage = file);
  }

  Future<void> formValidation() async {
    if (_croppedImage == null) {
      showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: context.l10n.errorSelectImage));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmePasswordController.text) {
      showDialog(
          context: context,
          builder: (_) =>
              ErrorDialog(message: context.l10n.errorNoMatchPasswords));
      return;
    }

    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              LoadingDialog(message: context.l10n.registeringAccount));

      try {
        UserCredential auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        User? currentUser = auth.user;

        if (currentUser != null) {
          firestorage.Reference reference = firestorage.FirebaseStorage.instance
              .ref()
              .child('users')
              .child(currentUser.uid);

          firestorage.UploadTask uploadTask = reference.putFile(_croppedImage!);
          firestorage.TaskSnapshot taskSnapshot = await uploadTask;

          downloadUrl = await taskSnapshot.ref.getDownloadURL();

          await saveDataToFireStore(currentUser);

          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } catch (error) {
        if (!mounted) return;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) =>
              ErrorDialog(message: context.l10n.storageError(error)),
        );
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: context.l10n.errorEnterRegInfo));
    }
  }

  Future<void> saveDataToFireStore(User currentUser) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    await userRef.set({
      "userID": currentUser.uid,
      "name": _nameController.text.trim(),
      "email": currentUser.email,
      "phone": _phoneController.value.international,
      "photoUrl": downloadUrl.trim(),
      "createdAt": DateTime.now(),
      "role": 'customer',
      "status": "approved",
    });

    if (!mounted) return;

    await userRef.collection('notifications').add({
      "userID": currentUser.uid,
      "title": context.l10n.welcomeNotifTitle,
      "body": context.l10n.welcomeNotifBody(_nameController.text.trim()),
      "createdAt": DateTime.now(),
      "isRead": false,
    });

    await sharedPreferences!.setString("uid", currentUser.uid);

    if (!mounted) return;
    Provider.of<CartProvider>(context).count;

    await saveUserPref<String>("email", currentUser.email.toString());
    await saveUserPref<String>("name", _nameController.text.trim());
    await saveUserPref<String>("photoUrl", downloadUrl.trim());
    await saveUserPref<String>("phone", _phoneController.value.international);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmePasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 16),

                // Avatar picker
                GestureDetector(
                  onTap: _getImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _croppedImage != null
                            ? FileImage(_croppedImage!)
                            : null,
                        child: _croppedImage == null
                            ? Icon(
                                Icons.add_photo_alternate_rounded,
                                size: MediaQuery.of(context).size.width * 0.18,
                                color: Colors.grey[400],
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade300,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              size: 24, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          data: Icons.person,
                          controller: _nameController,
                          hintText: context.l10n.hintName,
                          isObsecure: false,
                        ),
                        CustomPhoneField(
                          controller: _phoneController,
                          label: context.l10n.hintPhone,
                        ),
                        CustomTextField(
                          data: Icons.email,
                          controller: _emailController,
                          hintText: context.l10n.hintEmail,
                          isObsecure: false,
                        ),
                        CustomPasswordField(
                          controller: _passwordController,
                          label: context.l10n.hintPassword,
                          isRequired: true,
                          isConfirmation: false,
                        ),
                        CustomPasswordField(
                          controller: _confirmePasswordController,
                          label: context.l10n.hintConfPassword,
                          isRequired: true,
                          isConfirmation: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                AuthButton(
                  label: context.l10n.signUp,
                  onPressed: () async => await formValidation(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
