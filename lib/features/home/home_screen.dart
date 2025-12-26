import 'package:flutter/material.dart';
import '../../shared/widgets/add_shortcut_modal.dart';
import '../rides/destination_select_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lyft')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => destinationSelectModal(context, 'Destination'),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Where To',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () =>
                      destinationSelectModal(context, 'Schedule Ahead'),
                  child: const Text('Schedule Ahead'),
                ),
                const SizedBox(height: 12),
                _ShortcutTile(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () => addShortcutModal(context, 'Home', Icons.home),
                ),
                const SizedBox(height: 12),
                _ShortcutTile(
                  icon: Icons.work,
                  label: 'Work',
                  onTap: () => addShortcutModal(context, 'Work', Icons.work),
                ),
              ],
            ),

            Column(
              children: [
                const Text(
                  'You Are Here',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('Map will go here')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShortcutTile({
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )
              ),
              Text(
                'Add Shortcut',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                )
              ),
            ]
          )
        ]
      )
    );
  }
}