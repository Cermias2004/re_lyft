import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NameSettings extends StatefulWidget {
  const NameSettings({super.key});

  @override
  State<NameSettings> createState() => _NameSettingsState();
}

class _NameSettingsState extends State<NameSettings> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final userData = doc.data();

    _firstNameController.text = userData?['firstName'] ?? '';
    _lastNameController.text = userData?['lastName'] ?? '';
  }

  void _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
    }, SetOptions(merge: true));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: 'Name Settings'),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          hintText: ('First Name'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: ('Last Name'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _saveUserData,
                child: const Text('Save')
              ),
            ],
          ),
        ),
      ),
    );
  }
}