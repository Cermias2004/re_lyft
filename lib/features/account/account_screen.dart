import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import '../settings/help_screen.dart';
import '../rides/ride_history_screen.dart';
import '../payments/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _firstName;
  String? _lastName;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final userData = doc.data();

    if(!mounted) return;

    setState(() {
      _firstName = userData?['firstName'] ?? '';
      _lastName = userData?['lastName'] ?? '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D3A),
      body: SafeArea(
        child: isLoading 
          ? Center(child: CircularProgressIndicator(color: Color(0xFFFF00BF))) 
          : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[700],
                      child: Icon(Icons.person, size: 50, color: Colors.white)
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7B61FF)
                        ),
                        child: Icon(Icons.camera_alt, size: 12, color: Colors.white)
                      )
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$_firstName $_lastName',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('Account'),
                _buildListTile(Icons.history, 'Ride history', RideHistoryScreen()),
                _buildListTile(Icons.payment, 'Payments', PaymentScreen()),
                _buildListTile(Icons.help_outline, 'Help', HelpScreen()),
                _buildListTile(Icons.settings, 'Settings', SettingsScreen()),
              ]
            )
          )
      )
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String label, Widget destination) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination)
        );
        _loadUserData();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
