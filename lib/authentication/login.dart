import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/screens/home_screen.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/auth_button.dart';

import 'package:user_app/widgets/error_dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/widgets/custom_password_field.dart';
import 'package:user_app/widgets/unified_snackbar.dart';

import 'package:user_app/extensions/context_translate_ext.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(message: context.l10n.checkingCredentials),
    );

    User? currentUser;

    try {
      final authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      currentUser = authResult.user;

      if (currentUser != null) {
        await readDataAndSetDataLocally(currentUser);
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
            message: error.message ?? context.l10n.errorLoginFailed),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> formValidation() async {
    if (_formKey.currentState!.validate()) {
      await loginNow();
    } else {
      showDialog(
        context: context,
        builder: (_) =>
            ErrorDialog(message: context.l10n.errorEnterEmailOrPassword),
      );
    }
  }

  Future<void> readDataAndSetDataLocally(User currentUser) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection("users").doc(currentUser.uid);

      final snapshot =
          await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (!mounted) return;
      Navigator.pop(context);

      if (!snapshot.exists) {
        firebaseAuth.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: context.l10n.errorNoRecordFound),
        );
        return;
      }

      final data = snapshot.data()!;
      if (data["role"] != "customer" || data["status"] != "approved") {
        await firebaseAuth.signOut();
        if (!mounted) return;
        unifiedSnackBar(context.l10n.blockedAccountMessage, error: true);
        return;
      }

      await sharedPreferences!.setString("uid", currentUser.uid);
      cartItemCounter.displayCartListItemsNumber();
      await saveUserPref<String>("email", data["email"]);
      await saveUserPref<String>("name", data["name"]);
      await saveUserPref<String>("phone", data["phone"]);
      await saveUserPref<String>("photoUrl", data["photoUrl"]);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      if (e.code == 'unavailable') {
        unifiedSnackBar(context.l10n.networkUnavailable, error: true);
      } else {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(
              message: e.message ?? context.l10n.errorFetchingUserData),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/login.png',
                      height: 270,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                            isConfirmation: true,
                          ),
                          const SizedBox(height: 10),
                          AuthButton(
                            label: context.l10n.login,
                            onPressed: () async {
                              await formValidation();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
