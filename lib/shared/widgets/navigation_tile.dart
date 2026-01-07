import 'package:flutter/material.dart';

class NavigationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NavigationTile({super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios_sharp),
        ]
      ),
    );
  }
}