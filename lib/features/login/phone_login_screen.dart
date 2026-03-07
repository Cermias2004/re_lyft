import 'package:flutter/material.dart';
import './verify_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './name_setup_screen.dart';
import '../../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController(); 
  final _numberFocus = FocusNode();
  bool _numberFocused = false;
  String countryCode = '+1';
  String? _verificationId;
  bool validPhoneNumber = true;

  @override
  void initState() {
    super.initState();
    _numberFocus.addListener(() {
      if(!mounted) return;
      setState(() {_numberFocused = _numberFocus.hasFocus;});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _numberFocus.requestFocus;
    });

  }

  @override
  void dispose() {
    _phoneController.dispose();
    _numberFocus.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.white), 
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        iconSize: 28, 
                      ),
                      
                      const SizedBox(height: 24), 
                      
                      Text(
                        'Welcome aboard (or back)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.2, 
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        'To sign up or log in, enter your number.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF2d2d44),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _numberFocused ? Color(0xFF6B48FF) : Colors.grey[700]!,
                              width: _numberFocused ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone number',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text('🇺🇸', style: TextStyle(fontSize: 18)), 
                                      const SizedBox(width: 4),
                                      Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        countryCode,
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneController,
                                      focusNode: _numberFocus,
                                      autofocus: true,
                                      cursorColor: Color(0xFF6B48FF),
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        hintText: '',
                                      ),
                                      onChanged: (_) => setState(() {
                                        validPhoneNumber = true;
                                      }), 
                                    ),
                                  ),
                                  if (_phoneController.text.isNotEmpty)
                                    GestureDetector(
                                      onTap: () => setState(() => _phoneController.clear()),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[600],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.close, color: Colors.white, size: 14),
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
                              Icon(Icons.error_outline, color: Colors.red, size: 18),
                              const SizedBox(width: 8),
                              Expanded( 
                                child: Text(
                                  'Sorry, there was a problem using this phone number. Please make sure you\'ve entered the full number.',
                                  style: TextStyle(color: Colors.red, fontSize: 14),
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
                          onPressed: () {
                            final phone = _phoneController.text.replaceAll(RegExp(r'[\s\-\(\)]'), ''); // strip formatting
                            if (phone.length >= 10 && phone.length <= 15 && RegExp(r'^\d+$').hasMatch(phone)) {
                              _sendCode();
                            } else {
                              setState(() => validPhoneNumber = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6B48FF),
                            foregroundColor: Colors.white, 
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text(
                            'Continue with Phone',
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[700])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                          ),
                          Expanded(child: Divider(color: Colors.grey[700])),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _googleSignin,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[600]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://www.google.com/favicon.ico',
                                width: 20,
                                height: 20,
                                errorBuilder: (_, __, ___) => Icon(Icons.g_mobiledata, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  )
                )
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: account recovery flow
                  },
                  child: Text(
                    'Have a new number? Find your account',
                    style: TextStyle(
                      color: Color(0xFF6B48FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendCode() async {
    final raw = _phoneController.text;
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final phone = '$countryCode$digits';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        
        if (!mounted) return;
        
        if (doc.exists) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainApp()),
            (route) => false,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NameSetupScreen()),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) async {
        debugPrint('Phone auth failed: ${e.code} - ${e.message}');
        setState(() => validPhoneNumber = false);
      },
      codeSent: (String? verificationId, int? resendToken) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyPhoneScreen(number: _phoneController.text, verificationId: verificationId!)
          )
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      }
    );
  }

  Future<void> _googleSignin() async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if(googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final doc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

      if(!mounted) return;

      if(doc.exists){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainApp()),
          (route) => false
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NameSetupScreen()
          )
        );
      }
    }catch (e) {
      debugPrint('Google sign in error: $e');
    }
  }
}