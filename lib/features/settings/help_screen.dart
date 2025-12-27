import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(title: 'Help'),
            
          ]
        )
      )
    );
  }
}