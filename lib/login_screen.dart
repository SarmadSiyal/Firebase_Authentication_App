import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? error;

  bool _isPasswordHidden = true;

  bool get isEmailValid =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(emailController.text);

  bool get isPasswordValid => passwordController.text.length >= 6;

  Future<void> login() async {
    if (!isEmailValid || !isPasswordValid) {
      setState(() => error = "Please enter valid email and password.");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
        if (e.code == 'network-request-failed') {
          error = "No Internet Connection. Please try again.";
        } else if (e.code == 'user-not-found' ||
            e.code == 'invalid-credential') {
          error = "These credentials are not registered. Please sign up first.";
        } else if (e.code == 'wrong-password') {
          error = "Incorrect password. Try again.";
        } else {
          error = "Authentication failed. Please check your info.";
        }
      });
    } catch (_) {
      setState(() => error = "Unexpected error occurred. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 241, 246),
        foregroundColor: Colors.blueGrey,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
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
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Enter your Password',
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
                const SizedBox(
                  height: 8,
                ),
                if (error != null)
                  Text(error!, style: const TextStyle(color: Colors.red)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: login,
                        child: const Text("Login"),
                      ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: const Text("Don't have an account? Sign Up"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
