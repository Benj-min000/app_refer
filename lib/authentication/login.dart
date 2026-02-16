import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/widgets/custom_text_field.dart';
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
      builder: (_) => LoadingDialog(message: context.t.checkingCredentials),
    );

    User? currentUser;

    try {
      final authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      currentUser = authResult.user;

    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      Navigator.pop(context); 
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(message: error.message ?? context.t.errorLoginFailed),
      );
    }

    if (currentUser != null) {
      await readDataAndSetDataLocally(currentUser);
    }
  }

  Future<void> formValidation() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      await loginNow();
    } else {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(message: context.t.errorEnterEmailOrPassword),
      );
    }
  }

  Future<void> readDataAndSetDataLocally(User currentUser) async {
    try {
      final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid);

      final snapshot = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (!mounted) return;
      Navigator.pop(context);

      if(!snapshot.exists) {
        firebaseAuth.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: context.t.errorNoRecordFound),
        );
        return;
      }

      final data = snapshot.data()!;
      if (data["status"] != "Approved") {
        await firebaseAuth.signOut();
        if(!mounted) return;
        Fluttertoast.showToast(
          msg: context.t.blockedAccountMessage,
        );
        return;
      }

      await sharedPreferences!.setString("uid", currentUser.uid);

      await saveUserPref<String>("email", data["email"]);
      await saveUserPref<String>("name", data["name"]);
      await saveUserPref<String>("phone", data["phone"]);
      await saveUserPref<String>("photo", data["photo"]);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      
    } on FirebaseException catch(e) {
      if (!mounted) return;
      Navigator.pop(context);

      if (e.code == 'unavailable') {
        Fluttertoast.showToast(msg: context.t.networkUnavailable);
      } else {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: e.message ?? context.t.errorFetchingUserData),
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
    return Scaffold(
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
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          data: Icons.email,
                          controller: _emailController,
                          hintText: context.t.hintEmail,
                          isObsecure: false,
                        ),

                        CustomTextField(
                          data: Icons.lock,
                          controller: _passwordController,
                          hintText: context.t.hintPassword,
                          isObsecure: true,
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () async {
                            await formValidation();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade300,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          ),
                          child: Text(
                            context.t.login,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ]
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
