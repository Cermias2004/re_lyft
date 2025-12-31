import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../../shared/widgets/location_input_row.dart';
import '../rides/ride_select_screen.dart';

class DestinationSelectModal extends StatefulWidget {
  final String label;
  const DestinationSelectModal({
    required this.label,
  });

  @override
  State<DestinationSelectModal> createState() => _DestinationSelectModalState();
}
class _DestinationSelectModalState extends State<DestinationSelectModal> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomHeader(
                title: widget.label
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        Icon(Icons.donut_small_rounded),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextField(
                            controller: _pickupController,
                            decoration: InputDecoration(
                              hintText: 'Start',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        Icon(Icons.donut_small_sharp),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextField(
                            controller: _destinationController,
                            decoration: InputDecoration(
                              hintText: 'Destination',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed:() => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RideSelectScreen(destinationAddress: _destinationController.text, pickupAddress: _pickupController.text,)),
                ),
                icon: Icon(Icons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
