import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import '../settings/help_screen.dart';
import '../notifications/notifications_screen.dart';
import '../rides/ride_history_screen.dart';
import '../payments/payment_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  
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
            const Text('PERSON NAME'),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination)
        );
      },
    );
  }
}
