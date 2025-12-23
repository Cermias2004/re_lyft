import 'package:flutter/material.dart';

void addShortcutModal(BuildContext context, String label, IconData icon) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(child: Text('Add $label')),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(icon),
                    SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: ('Add Address'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
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
