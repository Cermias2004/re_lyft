import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CustomHeader(title: 'Help'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text('FAQs', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildFaqTile(
                      question: 'How do I request a ride?',
                      answer: "Tap 'Where To' on the home screen, enter your destination, select a ride type, and tap Select to confirm.",
                    ),
                    const SizedBox(height: 12),
                    _buildFaqTile(
                      question: 'How do I add a payment method?',
                      answer: "Go to Account > Payment and tap 'Add payment method' to enter your card details.",
                    ),
                    const SizedBox(height: 12),
                    _buildFaqTile(
                      question: 'How do I contact my driver?',
                      answer: "Once your ride is confirmed, you can call or message your driver directly from the ride screen.",
                    ),
                    const SizedBox(height: 12),
                    _buildFaqTile(
                      question: 'How do I cancel a ride?',
                      answer: "Tap on your active ride and select 'Cancel Ride'. Cancellation fees may apply.",
                    ),
                    const SizedBox(height: 32),
                    Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildContactTile(
                      icon: Icons.email_rounded,
                      text: 'support@emmatransport.com',
                    ),
                    const SizedBox(height: 12),
                    _buildContactTile(
                      icon: Icons.phone,
                      text: '1-800-EMMA-RIDE',
                    ),
                    const SizedBox(height: 32),
                    Text('Legal', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildLegalTile(text: 'Terms of Service'),
                    const SizedBox(height: 12),
                    _buildLegalTile(text: 'Privacy Policy'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
        iconColor: Color(0xFFFF00BF),
        collapsedIconColor: Colors.grey[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFF00BF), size: 24),
          const SizedBox(width: 16),
          Text(text, style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLegalTile({required String text}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[600]),
        ],
      ),
    );
  }
}