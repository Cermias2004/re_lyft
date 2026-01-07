import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../rides/ride_select_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './add_shortcut_modal.dart';

class DestinationSelectModal extends StatefulWidget {
  final DateTime? scheduleTime;

  const DestinationSelectModal({super.key, this.scheduleTime});

  @override
  State<DestinationSelectModal> createState() => _DestinationSelectModalState();
}

class _DestinationSelectModalState extends State<DestinationSelectModal> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  String selected = 'Destination';
  bool _isLoading = true;
  String? homeAddress;
  String? workAddress;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
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
      homeAddress = userData?['homeAddress'];
      workAddress = userData?['workAddress'];
      _isLoading = false;
    });
  }

  void _confirmDestination({bool home = false, bool work = false}) async {
    if (home == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideSelectScreen(
            pickupAddress: _pickupController.text.isEmpty
                ? 'Current Location'
                : _pickupController.text,
            destinationAddress: homeAddress ?? 'error',
            scheduleTime: widget.scheduleTime ?? DateTime.now(),
          ),
        ),
      );
    } else if (work == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideSelectScreen(
            pickupAddress: _pickupController.text.isEmpty
                ? 'Current Location'
                : _pickupController.text,
            destinationAddress: workAddress ?? 'error',
            scheduleTime: widget.scheduleTime ?? DateTime.now(),
          ),
        ),
      );
    } else if (_destinationController.text.isNotEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideSelectScreen(
            pickupAddress: _pickupController.text.isEmpty
                ? 'Current Location'
                : _pickupController.text,
            destinationAddress: _destinationController.text,
            scheduleTime: widget.scheduleTime ?? DateTime.now(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: _isLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF00BF)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomHeader(title: 'Destination'),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DestinationSelectModal(
                                        ),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.4,
                                    ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[700]!, width: 1),
                      ),
                      child: Column(
                        children: [
                          _buildLocationRow(
                            accentColor: Colors.indigoAccent,
                            controller: _pickupController,
                            isSelected: selected == 'Start',
                            label: 'Start',
                            onTap: () => setState(() => selected = 'Start'),
                            placeholder: 'Current location',
                          ),
                          Divider(
                            color: Colors.grey[700],
                            thickness: 1,
                            height: 1,
                          ),
                          _buildLocationRow(
                            accentColor: Color(0xFFFF00BF),
                            controller: _destinationController,
                            isSelected: selected == 'Destination',
                            label: 'Destination',
                            onTap: () =>
                                setState(() => selected = 'Destination'),
                            placeholder: 'Where to?',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmDestination,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF00BF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildShortcutTile(
                      icon: Icons.home,
                      label: 'Home',
                      hasAddress:
                          homeAddress != null && homeAddress!.isNotEmpty,
                      onTap: homeAddress != null
                          ? () => _confirmDestination(home: true)
                          : () async {
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
                      onTap: homeAddress != null
                          ? () => _confirmDestination(work: true)
                          : () async {
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
                  ],
                ),
              ),
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
              if (!hasAddress)
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

  Widget _buildLocationRow({
    required TextEditingController controller,
    required String placeholder,
    required Color accentColor,
    required bool isSelected,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.circle, color: accentColor, size: 12),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: isSelected
                    // Selected: label + TextField
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: TextStyle(color: accentColor, fontSize: 10),
                          ),
                          TextField(
                            controller: controller,
                            autofocus: true,
                            cursorColor: accentColor,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: placeholder,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7),
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            controller.text.isEmpty
                                ? placeholder
                                : controller.text,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
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
}
