import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideHistoryScreen extends StatefulWidget {
  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  List<Map<String, dynamic>> _rides = [];

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  void _loadRides() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      _rides = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(title: 'Ride History'),
            Expanded(
              child: ListView.builder(
                itemCount: _rides.length,
                itemBuilder: (context, index) {
                  final ride = _rides[index];
                  return ListTile(
                    title: Text('${ride['pickupAddress']} → ${ride['destinationAddress']}'),
                    subtitle: Text('${ride['rideType']} • \$${ride['fare']}'),
                    trailing: Text(ride['status']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}