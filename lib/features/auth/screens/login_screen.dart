
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../members/screens/dashboard_screen.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GymFlow Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            CustomTextFormField(label: 'Password', controller: _password, keyboardType: TextInputType.visiblePassword),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Login', onPressed: _login, loading: _loading),
          ],
        ),
      ),
    );
  }
}
