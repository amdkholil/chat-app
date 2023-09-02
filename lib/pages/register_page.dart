import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function() onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  String errorMessage = "";

  void signUp() async {
    errorMessage = "";

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != rePasswordController.text) {
      Navigator.pop(context);
      setState(() {
        errorMessage = "Password don't match!";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String err = e.code.replaceAll('-', ' ');
      errorMessage = '${err[0].toUpperCase()}${err.substring(1)}!';
      Navigator.pop(context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //   Logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                //   Welcome Message
                Text(
                  "Lets create an account for you!",
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 25),

                //   Email
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                ),

                const SizedBox(height: 15),

                //   Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                ),

                const SizedBox(height: 15),

                //   Confirm Password
                MyTextField(
                  controller: rePasswordController,
                  hintText: 'Confirm Password',
                  obsecureText: true,
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

                const SizedBox(height: 15),

                //   Signin Btn
                MyButton(
                  "Sign Up",
                  onTap: signUp,
                ),

                const SizedBox(
                  height: 20,
                ),

                //   goto register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign in now",
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
