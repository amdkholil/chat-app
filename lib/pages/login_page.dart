import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";

  void signIn() async {
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (context.mounted) Navigator.pop(context);
      errorMessage = '';
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message = e.code.replaceAll('-', ' ');
      errorMessage = '${message[0].toUpperCase()}${message.substring(1)}!';
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
                  "Welcome back, you've been missed!",
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
                  "Sign in",
                  onTap: signIn,
                ),

                const SizedBox(
                  height: 20,
                ),

                //   goto register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
