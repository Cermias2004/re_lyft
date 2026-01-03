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
  String? _firstName;
  String? homeAddress;
  String? workAddress;
  bool _isLoading = true;

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

    if (!mounted) return;

    setState(() {
      _firstName = userData?['firstName'] ?? '';
      homeAddress = userData?['homeAddress'];
      workAddress = userData?['workAddress'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D3A),
      body: Stack(
        children: [
          // Bottom layer: vertical fade to grey
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xFF2D2D3A),
                ],
                stops: [0.2, 0.5],
              ),
            ),
          ),
          // Top layer: horizontal purple to pink
          Container(
            height:250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B48FF),
                  Color(0xFFFF00BF),
                  Colors.transparent,
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF00BF)),
                  )
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Nice to see you, $_firstName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) =>
                                DestinationSelectModal(label: 'Destination'),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF3D3D4A),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 24,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Where are you going?',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => DestinationSelectModal(
                                  label: 'Schedule Ahead',
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF3D3D4A),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Schedule ahead',
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildShortcutTile(
                          icon: Icons.home,
                          label: 'Home',
                          hasAddress:
                              homeAddress != null && homeAddress!.isNotEmpty,
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => AddShortcutModal(
                                fieldName: 'homeAddress',
                                icon: Icons.home,
                                label: 'Home',
                              ),
                            );
                            _loadUserData();
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildShortcutTile(
                          icon: Icons.work,
                          label: 'Work',
                          hasAddress:
                              workAddress != null && workAddress!.isNotEmpty,
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => AddShortcutModal(
                                fieldName: 'workAddress',
                                icon: Icons.work,
                                label: 'Work',
                              ),
                            );
                            _loadUserData();
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'You are here',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF3D3D4A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'Map placeholder',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutTile({
    required IconData icon,
    required String label,
    required bool hasAddress,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFF00BF), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if(hasAddress)
              Text(
                'Add shortcut',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}