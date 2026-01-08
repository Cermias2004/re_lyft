import 'package:flutter/material.dart';
import './verify_phone.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController(); // 'final' - controller doesn't change
  bool isSelected = false;
  String countryCode = '+1';
  bool validPhoneNumber = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose(); // super.dispose() should be LAST, not first
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a2e), // Lyft uses dark purple-black, not pure black
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), // more horizontal padding for breathing room
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button - no Align needed, Column already has crossAxisAlignment.start
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white), // arrow_back not chevron_left - matches Lyft
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                iconSize: 28, // slightly smaller, cleaner
              ),
              
              const SizedBox(height: 24), // more space after back button
              
              // Headline
              Text(
                'Welcome aboard (or back)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.2, // slightly more line height for readability
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'To sign up or log in, enter your number.',
                style: TextStyle(
                  color: Colors.grey[400], // lighter grey for better contrast
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 24), // more space before input
              
              // Phone input container
              GestureDetector(
                onTap: () => setState(() => isSelected = true),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2d2d44), // subtle fill color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Color(0xFF6B48FF) : Colors.grey[700]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      Text(
                        'Phone number',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Color(0xFF6B48FF) : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Input row
                      Row(
                        children: [
                          // Country code with flag placeholder
                          Row(
                            children: [
                              Text('🇺🇸', style: TextStyle(fontSize: 18)), // flag emoji
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
                          // TextField - wrapped in Expanded so it takes remaining space
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              cursorColor: Color(0xFF6B48FF),
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true, // reduces default padding
                                contentPadding: EdgeInsets.zero,
                                hintText: '', // no hint, label above handles it
                              ),
                              onTap: () => setState(() => isSelected = true),
                              onChanged: (_) => setState(() {}), // rebuild to show/hide clear button
                            ),
                          ),
                          // Clear button - only show when there's text
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
              ),
              
              // Error message
              if (!validPhoneNumber)
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Expanded( // Expanded prevents overflow on long text
                        child: Text(
                          'Sorry, there was a problem using this phone number. Please make sure you\'ve entered the full number.',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 52, // slightly shorter, more modern
                child: ElevatedButton(
                  onPressed: () {
                    final phone = _phoneController.text.replaceAll(RegExp(r'[\s\-\(\)]'), ''); // strip formatting
                    if (phone.length >= 10 && phone.length <= 15 && RegExp(r'^\d+$').hasMatch(phone)) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneScreen()));
                    } else {
                      setState(() => validPhoneNumber = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6B48FF),
                    foregroundColor: Colors.white, // white text, not black
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26), // half of height for pill shape
                    ),
                  ),
                  child: Text(
                    'Continue with Phone',
                    style: TextStyle(
                      fontSize: 16, // smaller, more balanced
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // OR divider
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
              
              // Google sign in button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: implement Google sign in
                  },
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
              
              const Spacer(),
              
              // Bottom link
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
}