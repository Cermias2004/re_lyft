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
  bool isLoading = true;

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
    setState(() => isLoading=false);
  }

  void _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
    }, SetOptions(merge: true));
    if(!mounted) return;
    Navigator.pop(context);
  }

  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if(isLoading)
          Center(
            child: CircularProgressIndicator(color: Color(0xFFFF00BF))
          )
        else
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Change name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'first name',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    icon: Icon(Icons.person, color: Colors.grey[800]),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'last name',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    icon: Icon(Icons.person, color: Colors.grey[800]),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF00BF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ]
    );
  }


  
}
