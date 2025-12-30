import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddShortcutModal extends StatefulWidget {
  final String label;
  final IconData icon;
  final String fieldName;

  const AddShortcutModal({
    super.key,
    required this.label,
    required this.icon,
    required this.fieldName,
  });

  @override
  State<AddShortcutModal> createState() => _AddShortcutModalState();
}

class _AddShortcutModalState extends State<AddShortcutModal> {
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final userData = doc.data();

    _addressController.text = userData?[widget.fieldName] ?? '';
  }

  void _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      widget.fieldName: _addressController.text,
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
            children: [
              CustomHeader(
                title: 'Add ${widget.label}',
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(widget.icon),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: ('Add Address'),
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
