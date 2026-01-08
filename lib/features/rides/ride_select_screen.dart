import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../payments/payment_screen.dart';
import '../home/home_map.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RideSelectScreen extends StatefulWidget {
  final String pickupAddress;
  final String destinationAddress;
  final DateTime? scheduleTime;

  const RideSelectScreen({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
    this.scheduleTime,
  });

  @override
  State<RideSelectScreen> createState() => _RideSelectScreenState();
}

class _RideSelectScreenState extends State<RideSelectScreen> {
  String? _selectedRideType;
  IconData? icon;
  String? digits;
  DateTime? _scheduleTime;

  final List<Map<String, dynamic>> _rideOptions = [
    {
      'type': 'standard',
      'name': 'Standard',
      'time': '4 min',
      'price': 12.50,
      'seats': 4,
    },
    {'type': 'xl', 'name': 'XL', 'time': '6 min', 'price': 18.00, 'seats': 6},
    {
      'type': 'comfort',
      'name': 'Comfort',
      'time': '5 min',
      'price': 22.00,
      'seats': 4,
    },
    {
      'type': 'luxury',
      'name': 'Luxury',
      'time': '8 min',
      'price': 35.00,
      'seats': 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scheduleTime = widget.scheduleTime;
    _loadUserPayment();
  }

  void _loadUserPayment() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('paymentMethods').where('isDefault', isEqualTo: true).limit(1).get();

    if(!mounted) return;

    final data = doc.docs.firstOrNull;
    setState(() {
      icon = _getCardIcon(data?['type']);
      digits = data?['last4'];
    });
  }

  IconData _getCardIcon(String? type) {
    switch (type) {
      case 'visa':
        return FontAwesomeIcons.ccVisa;
      case 'mastercard':
        return FontAwesomeIcons.ccMastercard;
      case 'amex':
        return FontAwesomeIcons.ccAmex;
      default:
        return FontAwesomeIcons.creditCard;
    }
  }

  double get _selectedFare {
    final ride = _rideOptions.firstWhere(
      (r) => r['type'] == _selectedRideType,
      orElse: () => {'price': 0.0},
    );
    return ride['price'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D3A),
      body: Stack(
        children: [
          // Map
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.45,
            child: HomeMap(),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 60,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.right,
                      widget.pickupAddress,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.left,
                      widget.destinationAddress,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.35,
            maxChildSize: 0.75,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Back button row - sits above sheet, moves with it
                  Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2D2D3A),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 8,
                              offset: Offset(0,2)
                            )
                          ]
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF2D2D3A),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          // Drag handle
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // Schedule indicator (if scheduled)
                          if (_scheduleTime != null)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF3D3D4A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      color: Color(0xFFFF00BF),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Scheduled for ${DateFormat('MMM d, h:mm a').format(_scheduleTime!)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Ride options
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _rideOptions.length,
                              itemBuilder: (context, index) {
                                final ride = _rideOptions[index];
                                final isSelected = _selectedRideType == ride['type'];
                                return GestureDetector(
                                  onTap: () => setState(
                                    () => _selectedRideType = ride['type'],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFFFF00BF).withOpacity(0.15) : Color(0xFF3D3D4A),
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected
                                          ? Border.all(
                                              color: Color(0xFFFF00BF),
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.directions_car,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    ride['name'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    Icons.person,
                                                    size: 14,
                                                    color: Colors.grey[500],
                                                  ),
                                                  Text(
                                                    '${ride['seats']}',
                                                    style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${ride['time']} away',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '\$${ride['price'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Bottom action bar
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2D3A),
                              border: Border(
                                top: BorderSide(color: Colors.grey[800]!, width: 1),
                              ),
                            ),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async{
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PaymentScreen(),
                                          ));
                                          _loadUserPayment();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF3D3D4A),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(icon?? Icons.credit_card, color: Color(0xFFFF00BF), size: 18),
                                              const SizedBox(width: 8),
                                              Text(digits != null ? '****$digits' : 'Payment', style: TextStyle(color: Colors.white, fontSize: 14))
                                            ] 
                                          )
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3D3D4A),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.schedule,
                                              color: Color(0xFFFF00BF),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _scheduleTime == null ? DateFormat(
                                                'h:mm a',
                                              ).format(DateTime.now()) : '${_dayLabel(_scheduleTime!)}, ${TimeOfDay.fromDateTime(_scheduleTime!).format(context)}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _selectedRideType != null
                                          ? _requestRide
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFFF00BF),
                                        disabledBackgroundColor: Colors.grey[700],
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                      ),
                                      child: Text(
                                        _selectedRideType != null
                                            ? 'Confirm ${_rideOptions.firstWhere((r) => r['type'] == _selectedRideType)['name']} - \$${_selectedFare.toStringAsFixed(2)}'
                                            : 'Select a ride',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ]
              );
            },
          ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(t.year, t.month, t.day);
    final d = day.difference(today).inDays;

    if(d == 0) return "Today";
    if(d == 1) return "Tomorrow";

    return '${t.month}/${t.day}';
  }

  void _requestRide() async {
    if (_selectedRideType == null) return;

    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('rides').add({
      'userId': user!.uid,
      'pickupAddress': widget.pickupAddress,
      'destinationAddress': widget.destinationAddress,
      'rideType': _selectedRideType,
      'status': _scheduleTime != null ? 'scheduled' : 'completed',
      'fare': _selectedFare,
      'driverName': 'John D.',
      'scheduledAt': _scheduleTime != null
          ? Timestamp.fromDate(_scheduleTime!)
          : null,
      'createdAt': FieldValue.serverTimestamp(),
      'completedAt': _scheduleTime == null
          ? FieldValue.serverTimestamp()
          : null,
    });

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
