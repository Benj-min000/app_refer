import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/widgets/custom_text_field.dart';

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
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: 'Checking Credentials'),
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
        builder: (_) => ErrorDialog(message: error.message ?? "Login failed"),
      );
    }

    if (currentUser != null) {
      // -----------------------------------------------------------------------
      // This code needs to be commented out if using the app with FireStorage
      // -----------------------------------------------------------------------
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      // -----------------------------------------------------------------------

      //await readDataAndSetDataLocally(currentUser);
    }
  }

  Future<void> formValidation() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      await loginNow(); // login
    } else {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(message: "Please Enter Email or Password"),
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
          builder: (_) => const ErrorDialog(message: "No record found"),
        );
        return;
      }

      final data = snapshot.data()!;
      if (data["status"] != "Approved") {
        await firebaseAuth.signOut();
        Fluttertoast.showToast(
          msg: "Admin has blocked your account\n\nMail to: admin@gmail.com",
        );
        return;
      }

      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", data["email"]);
      await sharedPreferences!.setString("name", data["name"]);
      await sharedPreferences!.setString("photo", data["photo"]);
      await sharedPreferences!.setStringList(
        "userCart", List<String>.from(data["userCart"] ?? [])
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      
    } on FirebaseException catch(e) {
      if (!mounted) return;
      Navigator.pop(context);

      if (e.code == 'unavailable') {
        Fluttertoast.showToast(msg: "Network unavailable. Please try again.");
      } else {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: e.message ?? "Error fetching user data"),
        );
      }
    }
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
                          hintText: 'Email',
                          isObsecre: false,
                        ),

                        CustomTextField(
                          data: Icons.lock,
                          controller: _passwordController,
                          hintText: 'Password',
                          isObsecre: true,
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: () async {
                            await formValidation();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade300,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          ),
                          child: const Text(
                            "Login",
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
