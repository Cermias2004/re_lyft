import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomHeader(title: 'Settings'),
            ]
          )
        )
      )
    );
  }
}