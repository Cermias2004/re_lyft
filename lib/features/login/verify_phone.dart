import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import './name_setup_screen.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String verificationId;
  final String number;

  const VerifyPhoneScreen({
    super.key,
    required this.number,
    required this.verificationId,
  });

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _codeController = TextEditingController();
  final _codeFocus = FocusNode();
  bool _codeFocused = false;
  bool validPhoneNumber = true;

  @override
  void initState() {
    super.initState();
    _codeFocus.addListener(() {
      if (!mounted) return;
      setState(() => _codeFocused = _codeFocus.hasFocus);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocus.requestFocus;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocus.dispose();
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
                        'Check your texts for the super-secret code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'To confirm your number, enter the code.',
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
                            color: _codeFocused
                                ? Color(0xFF6B48FF)
                                : Colors.grey[700]!,
                            width: _codeFocused ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '6-digit code',
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
                                    focusNode: _codeFocus,
                                    controller: _codeController,
                                    cursorColor: Color(0xFF6B48FF),
                                    autofocus: true,
                                    keyboardType: TextInputType.phone,
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
                                if (_codeController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _codeController.clear()),
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
                      if (!validPhoneNumber)
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
                                  'Sorry, there was a problem with the code. Please make sure you\'ve entered the correct code.',
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
                          onPressed: _verifyCode,
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

  Future<void> _verifyCode() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _codeController.text,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'phoneNumber': widget.number}, SetOptions(merge: true));
      if (!mounted) return;

      if (doc.exists) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainApp()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NameSetupScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => validPhoneNumber = false);
    }
  }
}
