import 'package:flutter/material.dart';

class LocationInputRow extends StatelessWidget {
  final String label;
  final IconData icon;

  const LocationInputRow({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Row(
      children: [
        const SizedBox(width: 2),
        Icon(icon),
        const SizedBox(width: 8),
        Flexible(
          child: TextField(
            decoration: InputDecoration(
              hintText: (label),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}