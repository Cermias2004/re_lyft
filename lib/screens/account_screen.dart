import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_3_sharp),
            ),
            SizedBox(height: 12),
            Text('PERSON NAME'),
            SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                print('WOW SO COOL GUY');
              },
              child: Text('view profile', style: TextStyle(fontSize: 12)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            _buildAccountButton(Icons.notifications, 'Notifications'),
            _buildAccountButton(Icons.history, 'Ride History'),
            _buildAccountButton(Icons.payment, 'Payment'),
            _buildAccountButton(Icons.help, 'Help'),
            _buildAccountButton(Icons.settings, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountButton(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        print('$label pressed');
      },
    );
  }
}
