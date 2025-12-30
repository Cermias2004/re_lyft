import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _Login() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }catch (e) {
      debugPrint(e.toString());
    }
  }

  void _SignUp() async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'email': _emailController.text,
        'firstName': '',
        'lastName': '',
        'phoneNumber': '',
        'homeAddress': '',
        'workAddress': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    catch (e) {
        debugPrint(e.toString());
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      Icon(Icons.email),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextField(
                          obscureText: false,
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: ('Email'),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      Icon(Icons.lock),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: ('Password'),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _Login(),
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () => _SignUp(),
                  child: const Text('Sign Up'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}