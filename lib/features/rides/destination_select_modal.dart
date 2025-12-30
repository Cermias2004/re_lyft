import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../../shared/widgets/location_input_row.dart';

void destinationSelectModal(BuildContext context, String label) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomHeader(
                title: label
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    LocationInputRow(
                      label: 'Start',
                      icon: Icons.donut_small_rounded,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    LocationInputRow(
                      label: 'Destination',
                      icon: Icons.donut_small_sharp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
