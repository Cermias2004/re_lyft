import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _firstFocus = FocusNode();
  final _lastFocus = FocusNode();
  bool _firstFocused = false;
  bool _lastFocused = false;
  bool _isValidName = true;

  @override
  void initState() {
    super.initState();
    _firstFocus.addListener(() {
      if (!mounted) return;
      setState(() {
        _firstFocused = _firstFocus.hasFocus;
      });
    });
    _lastFocus.addListener(() {
      if (!mounted) return;
      setState(() {
        _lastFocused = _lastFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a2e),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        constraints: BoxConstraints(),
                        iconSize: 28,
                      ),

                      const SizedBox(height: 24),
                      Text(
                        'What\'s your name?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Drivers will only see your first name, because we like to keep things casual.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF2d2d44),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _firstFocused
                                ? Color(0xFF6B48FF)
                                : Colors.grey[700]!,
                            width: _firstFocused ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'First name',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: _firstFocus,
                                    controller: _firstController,
                                    cursorColor: Color(0xFF6B48FF),
                                    autofocus: true,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: '',
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                                if (_firstController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => setState(
                                      () => _firstController.clear(),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF2d2d44),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _lastFocused
                                ? Color(0xFF6B48FF)
                                : Colors.grey[700]!,
                            width: _lastFocused ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last name',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: _lastFocus,
                                    controller: _lastController,
                                    cursorColor: Color(0xFF6B48FF),
                                    autofocus: false,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: '',
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                                if (_lastController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _lastController.clear()),
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!_isValidName)
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Sorry, please make sure you type in your full name.',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _saveUserData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6B48FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserData() async {
    if (_lastController.text.isEmpty || _firstController.text.isEmpty) {
      setState(() => _isValidName = false);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'firstName': _firstController.text,
      'lastName': _lastController.text,
    }, SetOptions(merge: true));

    if (!mounted) return;
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainApp()),
      (route) => false,
    );
  }
}
