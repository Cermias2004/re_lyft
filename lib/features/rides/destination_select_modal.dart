import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';

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
                    _LocationInputRow(
                      label: 'Start',
                      icon: Icons.donut_small_rounded,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    _LocationInputRow(
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

class _LocationInputRow extends StatelessWidget {
  final String label;
  final IconData icon;

  const _LocationInputRow({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Icon(icon),
        const SizedBox(width: 8),
        Flexible(
          child: TextField(
            decoration: InputDecoration(
              hintText: (label),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
