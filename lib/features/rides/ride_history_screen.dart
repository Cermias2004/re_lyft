import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  List<Map<String, dynamic>> _rides = [];
  bool isLoading = true;

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

    if (!mounted) return;

    setState(() {
      _rides = snapshot.docs.map((doc) => doc.data()).toList();
      isLoading = false;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CustomHeader(title: 'Ride History'),
            ),
            if(isLoading) 
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF00BF))
                )
              )
            else if(_rides.isEmpty)
              Expanded(
                child: Center(
                  child: Text('No rides yet',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  )
                )
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _rides.length,
                  itemBuilder: (context, index) {
                    final ride = _rides[index];
                    return _buildRideTile(
                      pickupAddress: ride['pickupAddress'] ?? '',
                      destinationAddress: ride['destinationAddress'] ?? '',
                      rideType: ride['rideType'] ?? '',
                      fare: (ride['fare'] ?? 0).toDouble(),
                      status: ride['status'] ?? '',
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideTile({
    required String pickupAddress,
    required String destinationAddress,
    required String rideType,
    required double fare,
    required String status,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom:12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car, color: Color(0xFFFF00BF), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pickupAddress → $destinationAddress',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$rideType • \$${fare.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'completed' ? Colors.green[100] : Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'completed' ? Colors.green[800] : Colors.orange[800],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
