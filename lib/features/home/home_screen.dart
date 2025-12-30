import 'package:flutter/material.dart';
import '../rides/add_shortcut_modal.dart';
import '../rides/destination_select_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? homeAddress;
  String? workAddress;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final userData = doc.data();

    setState(() {
      homeAddress = userData?['homeAddress'];
      workAddress = userData?['workAddress'];
    });
  }

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
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddShortcutModal(
                      label: 'Home',
                      icon: Icons.home,
                      fieldName: 'homeAddress',
                    ),
                  ),
                  showAddShortcut: homeAddress == null || homeAddress!.isEmpty,
                ),
                const SizedBox(height: 12),
                _ShortcutTile(
                  icon: Icons.work,
                  label: 'Work',
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddShortcutModal(
                      label: 'Work',
                      icon: Icons.work,
                      fieldName: 'workAddress',
                    ),
                  ),
                  showAddShortcut: workAddress == null || workAddress!.isEmpty,
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
  final bool showAddShortcut;

  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.showAddShortcut,
  });

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (showAddShortcut)
                Text(
                  'Add Shortcut',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
