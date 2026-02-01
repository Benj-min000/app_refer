import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/mainScreens/home_screen.dart';

import 'package:user_app/global/global.dart';

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
  
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(context: context, builder: (_) => const ErrorDialog(message: "Please select an image")
      );
    }

    if (_passwordController.text != _confirmePasswordController.text) {
      showDialog(context: context, builder: (_) => const ErrorDialog(message: "Passwords don't match"));
      return;
    }

    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      showDialog(context: context, builder: (_) => const LoadingDialog(message: "Registering Account..."));
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference reference = fStorage.FirebaseStorage.instance
          .ref()
          .child('users')
          .child(fileName);

        fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));

        fStorage.TaskSnapshot taskSnapshot = await uploadTask;

        // Get the URL only AFTER success
        sellerImageUrl = await taskSnapshot.ref.getDownloadURL();

        authenticateSellerAndSignUp();

      } catch (error) {
          if(!mounted) return;
          Navigator.pop(context); 
          showDialog(context: context, builder: (_) => ErrorDialog(message: "Storage Error: $error"));
        }
    } else {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(message: "Please Enter Required info for registration")
      );
    }
  }

  Future<void> authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      if(!mounted) return;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) =>  ErrorDialog(message: error.message.toString())
        );
    });
    if (currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        if(!mounted) return;
        Navigator.pop(context);
        Route newRoute =
            MaterialPageRoute(builder: (context) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future<void> saveDataToFireStore(User currentUser) async {
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": _nameController.text.trim(),
      "photo": sellerImageUrl,
      "status": "Approved",
      "userCart": ['garbageValue'],
    });

    // Save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", _nameController.text.trim());
    await sharedPreferences!.setString("photo", sellerImageUrl);
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
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
                  hintText: 'Name',
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.email,
                  controller: _emailController,
                  hintText: 'Email',
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: _passwordController,
                  hintText: 'Password',
                  isObsecre: true,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: _confirmePasswordController,
                  hintText: 'Confirm Password',
                  isObsecre: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async => {
              await formValidation(),
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade300,
              padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
            child: const Text(
              "Sign Up",
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
