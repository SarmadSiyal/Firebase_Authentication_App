import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? error;

  bool _isPasswordHidden = true;

  bool get isEmailValid =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(emailController.text);

  bool get isPasswordValid => passwordController.text.length >= 6;

  Future<void> signUp() async {
    if (!isEmailValid || !isPasswordValid) {
      setState(() => error = "Please enter valid email and password.");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      emailController.clear();
      passwordController.clear();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          error = "Email already in use.";
        } else if (e.code == 'network-request-failed') {
          error = "No Internet Connection.";
        } else {
          error = e.message;
        }
      });
    } catch (_) {
      setState(() => error = "Unexpected error occurred. Try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                  labelText: 'Enter email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    }),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: signUp,
                      child: const Text("Sign Up"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
