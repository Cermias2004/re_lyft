import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../payments/payment_screen.dart';

class RideSelectScreen extends StatefulWidget {
  final String pickupAddress;
  final String destinationAddress;

  const RideSelectScreen({
    required this.pickupAddress,
    required this.destinationAddress,
  });

  @override
  State<RideSelectScreen> createState() => _RideSelectScreenState();
}

class _RideSelectScreenState extends State<RideSelectScreen>{
  String? _selectedRideType;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          // The GPS image.
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: Text(widget.pickupAddress, overflow: TextOverflow.ellipsis)),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward, size: 16)),
                          Flexible(child: Text(widget.destinationAddress, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize:0.8,
            builder: (context, scrollController) {
              return Container(
                color: Colors.grey[900],
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: (_) {},
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          ListTile(
                            leading: Icon(Icons.directions_car),
                            title: Text("Standard"),
                            subtitle: Text('4 min away'),
                            trailing: Text('\$12.50'),
                            selected: _selectedRideType == 'standard',
                            selectedTileColor: Colors.pink.withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                _selectedRideType = 'standard';
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.directions_car),
                            title: Text("XL"),
                            subtitle: Text('6 min away'),
                            trailing: Text('\$18.00'),
                            selected: _selectedRideType == 'xl',
                            selectedTileColor: Colors.pink.withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                _selectedRideType = 'xl';
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.directions_car),
                            title: Text("Comfort"),
                            subtitle: Text('5 min away'),
                            trailing: Text('\$22.00'),
                            selected: _selectedRideType == 'comfort',
                            selectedTileColor: Colors.pink.withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                _selectedRideType = 'comfort';
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.directions_car),
                            title: Text("Luxury"),
                            subtitle: Text('8 min away'),
                            trailing: Text('\$35.00'),
                            selected: _selectedRideType == 'luxury',
                            selectedTileColor: Colors.pink.withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                _selectedRideType = 'luxury';
                              });
                            },
                          ),
                        ]
                      ),
                    )
                  ]
                )
              );
            }
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right:0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[500],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen())),
                          child: Text("money"),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () => {},
                          child: Text("schedule ahead"),
                        ),
                      ]
                    )
                  ),
                  ElevatedButton(
                    onPressed: _requestRide,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 300, vertical: 30),
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text('Select'),
                  ),
                  SizedBox(height: 10),
                ]
              )
            )
          ),
        ]
      ),
    );
  }

  void _requestRide() async {
    if (_selectedRideType == null) return;  // don't submit without selection
    
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('rides').add({
      'userId': user!.uid,
      'pickupAddress': widget.pickupAddress,
      'destinationAddress': widget.destinationAddress,
      'rideType': _selectedRideType,
      'status': 'completed',
      'fare': 12.50,
      'driverName': 'John D.',
      'createdAt': FieldValue.serverTimestamp(),
      'completedAt': FieldValue.serverTimestamp(),
    });

    Navigator.popUntil(context, (route) => route.isFirst);
  }
}