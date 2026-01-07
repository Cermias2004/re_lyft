import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/widgets/custom_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _selectedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('paymentMethods')
        .orderBy('createdAt', descending: true)
        .get();

    if(!mounted) return;

    setState(() {
      _paymentMethods = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final defaultCard = _paymentMethods
          .where((m) => m['isDefault'] == true)
          .firstOrNull;
      _selectedId = defaultCard?['id'] ?? _paymentMethods.firstOrNull?['id'];
      _isLoading = false;
    });
  }

  void _showAddPaymentModal() {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Payment Method',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Card Number',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  icon: Icon(Icons.credit_card, color: Colors.grey[800]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: expiryController,
                keyboardType: TextInputType.datetime,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'MM/YY',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  icon: Icon(Icons.calendar_today, color: Colors.grey[800]),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final cardNumber = cardNumberController.text;
                  final expiry = expiryController.text;

                  if (cardNumber.length >= 4 && expiry.isNotEmpty) {
                    await _addPaymentMethod(
                      last4: cardNumber.substring(cardNumber.length - 4),
                      expiry: expiry,
                      type: _detectCardType(cardNumber: cardNumber),
                    );
                    Navigator.pop(modalContext);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF00BF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _addPaymentMethod({
    required String last4,
    required String expiry,
    required String type,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final isFirst = _paymentMethods.isEmpty;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('paymentMethods')
        .add({
          'last4': last4,
          'expiry': expiry,
          'type': type,
          'isDefault': isFirst,
          'createdAt': FieldValue.serverTimestamp(),
        });
    _loadPaymentMethods();
  }

  String _detectCardType({required String cardNumber}) {
    if(cardNumber.startsWith('3')) return 'amex';
    if(cardNumber.startsWith('4')) return 'visa';
    if(cardNumber.startsWith('5'))return 'mastercard';
    return 'card';
  }

  void _setDefaultPayment(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    final batch = FirebaseFirestore.instance.batch();

    for (var method in _paymentMethods) {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('paymentMethods')
          .doc(method['id']);
      batch.update(ref, {'isDefault': method['id'] == id});
    }
    await batch.commit();
    setState(() => _selectedId = id);
  }

  void _deletePaymentMethod(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('paymentMethods')
        .doc(id)
        .delete();
    _loadPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomHeader(title: 'Payment'),
            ),
            if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF00BF)),
                ),
              )
            else if (_paymentMethods.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No payment methods',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final card = _paymentMethods[index];
                    final isSelected = card['id'] == _selectedId;
                    return GestureDetector(
                      onTap: () => _setDefaultPayment(card['id']),
                      onLongPress: () => _showDeleteDialog(card['id']),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: Color(0xFFFF00BF), width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            FaIcon(_getCardIcon(card['type']),
                              color: Colors.grey[800],
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•••• ${card['last4']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Expires ${card['expiry']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFFFF00BF),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _showAddPaymentModal,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Color(0xFFFF00BF)),
                      const SizedBox(width: 16),
                      Text(
                        'Add payment method',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Delete Card?', style: TextStyle(color: Colors.white)),
        content: Text(
          'This cannot be undone.',
          style: TextStyle(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePaymentMethod(id);
            },
            child: Text('Delete', style: TextStyle(color: Color(0xFFFF00BF))),
          ),
        ],
      ),
    );
  }
}
