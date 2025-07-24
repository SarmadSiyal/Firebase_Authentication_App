import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  String? message;
  bool isLoading = false;
  bool get isEmailValid =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(emailController.text);

  Future<void> resetPassword() async {
    if (!isEmailValid) {
      setState(() {
        message = "Please enter a valid email address.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      emailController.clear();
      setState(() {
        message = '✅ Password reset email sent!';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          message = "User not found with this email.";
        } else if (e.code == 'network-request-failed') {
          message = "No Internet connection.";
        } else {
          message = e.message;
        }
      });
    } catch (_) {
      setState(() => message = "Unexpected error occurred.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: const Color(0xFFCBF1F5),
        foregroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3FDFD), Color(0xFFCBF1F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              if (message != null)
                Text(message!, style: const TextStyle(color: Colors.blue)),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: resetPassword,
                      child: const Text("Send Reset Link"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
