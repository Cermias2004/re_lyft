import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../../shared/widgets/navigation_tile.dart';
import '../rides/add_shortcut_modal.dart';
import './email_settings.dart';
import './name_settings.dart';
import './phone_settings.dart';
import './dark_mode_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(title: 'Settings'),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.person_3_sharp, label: 'Name', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NameSettings()),
                );
              }),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.mail, label: 'Email', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailSettings()),
                );
              }),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.phone, label: 'Phone', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhoneSettings()),
                );
              }),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.dark_mode, label: 'Dark Mode',   onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DarkModeSettings())
                );
              }),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.home, label: 'Home', onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddShortcutModal(label: 'Home', icon: Icons.home, fieldName: 'homeAddress',),
                )
              ),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.work, label: 'Work', onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddShortcutModal(label: 'Work', icon: Icons.work, fieldName: 'workAddress'),
              )),
              const SizedBox(width: 12),
              NavigationTile(icon: Icons.exit_to_app_sharp, label: 'Log out', onTap: () async{
                Navigator.of(context).popUntil((route) => route.isFirst);
                await FirebaseAuth.instance.signOut();
              }),
            ]
          )
        )
      )
    );
  }
}