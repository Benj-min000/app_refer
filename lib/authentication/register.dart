import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

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
  final TextEditingController _confirmePasswordController = TextEditingController();
  late final PhoneController _phoneController;
  
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String downloadUrl = "";

  Future<void> _getImage() async {
    XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      imageQuality: 85,
    );

    if (selectedImage != null) {
      setState(() {
        imageXFile = selectedImage;
      });
    }
  }

  void initState() {
    super.initState();
    _phoneController = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
    );
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context, 
        builder: (_) => ErrorDialog(message: context.t.errorSelectImage)
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmePasswordController.text) {
      showDialog(context: context, builder: (_) => ErrorDialog(message: context.t.errorNoMatchPasswords));
      return;
    }

    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (_) => LoadingDialog(message: context.t.registeringAccount)
      );

      try {
        print("$_passwordController.text");
        UserCredential auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        User? currentUser = auth.user;

        if (currentUser != null) {
          String fileName = currentUser.uid; 
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
            .ref()
            .child('users')
            .child(fileName);
          
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask;

          downloadUrl = await taskSnapshot.ref.getDownloadURL();

          await saveDataToFireStore(currentUser);

          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const HomeScreen())
          );
        }
      } catch (error) {
          if(!mounted) return;
          Navigator.pop(context); 
          showDialog(
            context: context, 
            builder: (_) => ErrorDialog(message: context.t.storageError(error)),
          );
        }
    } else {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(message: context.t.errorEnterRegInfo)
      );
    }
  }

  Future<void> saveDataToFireStore(User currentUser) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    await userRef.set({
      "email": currentUser.email,
      "name": _nameController.text.trim(),
      "photo": downloadUrl.trim(),
      "status": "Approved",
      "phone": _phoneController.value.international
    });
    
    // Initializing notifications
    await userRef.collection('notifications').add({
      "userID": currentUser.uid,
      "title": "Welcome!",
      "body": "Thanks for joining our app, ${_nameController.text.trim()}!",
      "timestamp": DateTime.now(),
      "isRead": false,
    });

    // Save data localy
    await sharedPreferences!.setString("uid", currentUser.uid); // MASTER KEY
    await saveUserPref<String>("email", currentUser.email.toString());
    await saveUserPref<String>("name", _nameController.text.trim());
    await saveUserPref<String>("photo", downloadUrl.trim());
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              await _getImage();
            },
            child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(
                        File(imageXFile!.path),
                      ),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.20,
                        color: Colors.grey,
                      )
                    : null),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: _nameController,
                  hintText: context.t.hintName,
                  isObsecure: false,
                ),
                
                CustomPhoneField(
                  controller: _phoneController,
                  label: "Phone Number",
                ),

                CustomTextField(
                  data: Icons.email,
                  controller: _emailController,
                  hintText: context.t.hintEmail,
                  isObsecure: false,
                ),
                
                CustomPasswordField(
                  controller: _passwordController,
                  label: context.t.hintPassword,
                  isRequired: true,
                  isConfirmation: false,
                ),

                CustomPasswordField(
                  controller: _confirmePasswordController,
                  label: context.t.hintConfPassword,
                  isRequired: true,
                  isConfirmation: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async => {
              await formValidation(),
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade300,
              padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
            child: Text(
              context.t.signUp,
              style:
                TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                  fontWeight: FontWeight.bold
                ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

