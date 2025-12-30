import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneSettings extends StatefulWidget {
  const PhoneSettings({super.key});

  @override
  State<PhoneSettings> createState() => _PhoneSettingsState();
}
class _PhoneSettingsState extends State<PhoneSettings> {
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final userData = doc.data();

    _phoneNumberController.text = userData?['phoneNumber'] ?? '';
  }

  void _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'phoneNumber': _phoneNumberController.text,
    });
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
              const CustomHeader(title: 'Phone Settings'),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          hintText: ('Phone Number'),
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
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}