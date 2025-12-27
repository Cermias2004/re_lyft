import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../../core/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class DarkModeSettings extends StatelessWidget {
  DarkModeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: 'Dark Mode Settings'),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.dark_mode),
                  const SizedBox(width: 8),
                  const Text('Enable Dark Mode'),
                  const Spacer(),
                  Switch(
                    value: themeManager.isDarkMode,
                    onChanged: (_) => themeManager.toggleDarkMode(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}