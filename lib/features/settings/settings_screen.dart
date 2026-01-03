import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../../shared/widgets/navigation_tile.dart';
import '../rides/add_shortcut_modal.dart';
import './email_settings.dart';
import './name_settings.dart';
import './phone_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CustomHeader(title: 'Settings'),
            ),
            const SizedBox(height: 36),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.person,
                      label: 'Name',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => NameSettings(),
                      )
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.mail,
                      label: 'Email',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => EmailSettings(),
                      )
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.phone,
                      label: 'Phone',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => PhoneSettings(),
                      )
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.home,
                      label: 'Home Address',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => AddShortcutModal(
                          label: 'Home',
                          icon: Icons.home,
                          fieldName: 'homeAddress',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.work,
                      label: 'Work Address',
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => AddShortcutModal(
                          label: 'Work',
                          icon: Icons.work,
                          fieldName: 'workAddress',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      icon: Icons.exit_to_app,
                      label: 'Log out',
                      isDestructive: true,
                      onTap: () async {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDestructive ? Colors.red : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600])
          ]
        )
      )
    );
  }
}
