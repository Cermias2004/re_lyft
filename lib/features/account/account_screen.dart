import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import '../settings/help_screen.dart';
import '../notifications/notifications_screen.dart';
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

    setState(() {
      _firstName = userData?['firstName'] ?? '';
      _lastName = userData?['lastName'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_3_sharp),
            ),
            const SizedBox(height: 12),
             Text('$_firstName $_lastName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                print('WOW SO COOL GUY');
              },
              child: const Text('CLosed down uwu', style: TextStyle(fontSize: 12)),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildAccountButton(context, Icons.notifications, 'Notifications', NotificationsScreen()),
            _buildAccountButton(context, Icons.history, 'Ride History', RideHistoryScreen()),
            _buildAccountButton(context, Icons.payment, 'Payment', PaymentScreen()),
            _buildAccountButton(context, Icons.help, 'Help', HelpScreen()),
            _buildAccountButton(context, Icons.settings, 'Settings', SettingsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountButton(BuildContext context, IconData icon, String label, Widget destination) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () async{
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination)
        );
        _loadUserData();
      },
    );
  }
}
