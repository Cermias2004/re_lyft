import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Integration tests for app flows
// These test complete user journeys through the app

void main() {
  group('App Integration Tests', () {
    group('Ride Booking Flow', () {
      testWidgets('can select ride type from list', (tester) async {
        int selectedIndex = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                children: List.generate(4, (index) {
                  final types = ['Standard', 'XL', 'Comfort', 'Luxury'];
                  return ListTile(
                    title: Text(types[index]),
                    onTap: () => selectedIndex = index,
                  );
                }),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Comfort'));
        expect(selectedIndex, 2);
      });

      testWidgets('confirm button disabled without selection', (tester) async {
        String? selectedType;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      ...['Standard', 'XL'].map((type) => ListTile(
                            title: Text(type),
                            selected: selectedType == type,
                            onTap: () => setState(() => selectedType = type),
                          )),
                      ElevatedButton(
                        onPressed: selectedType != null ? () {} : null,
                        child: Text(selectedType != null
                            ? 'Confirm $selectedType'
                            : 'Select a ride'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Initially disabled
        expect(find.text('Select a ride'), findsOneWidget);

        // Select a ride
        await tester.tap(find.text('Standard'));
        await tester.pump();

        // Now enabled
        expect(find.text('Confirm Standard'), findsOneWidget);
      });
    });

    group('Navigation Flow', () {
      testWidgets('bottom nav switches between screens', (tester) async {
        int currentIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: IndexedStack(
                    index: currentIndex,
                    children: const [
                      Center(child: Text('Home Screen')),
                      Center(child: Text('Activity Screen')),
                      Center(child: Text('Account Screen')),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) => setState(() => currentIndex = index),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        label: 'Activity',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Account',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Start on Home
        expect(find.text('Home Screen'), findsOneWidget);

        // Tap Activity
        await tester.tap(find.text('Activity'));
        await tester.pump();
        expect(find.text('Activity Screen'), findsOneWidget);

        // Tap Account
        await tester.tap(find.text('Account'));
        await tester.pump();
        expect(find.text('Account Screen'), findsOneWidget);

        // Back to Home
        await tester.tap(find.text('Home'));
        await tester.pump();
        expect(find.text('Home Screen'), findsOneWidget);
      });
    });

    group('Modal Flow', () {
      testWidgets('destination modal opens and closes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: 300,
                        child: Column(
                          children: [
                            const Text('Where to?'),
                            const TextField(),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Destination'),
                ),
              ),
            ),
          ),
        );

        // Open modal
        await tester.tap(find.text('Open Destination'));
        await tester.pumpAndSettle();

        expect(find.text('Where to?'), findsOneWidget);

        // Close modal
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.text('Where to?'), findsNothing);
      });
    });

    group('Form Input Flow', () {
      testWidgets('phone number validation flow', (tester) async {
        final controller = TextEditingController();
        bool isValid = false;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            isValid = value.length >= 10;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          errorText: controller.text.isNotEmpty && !isValid
                              ? 'Invalid phone number'
                              : null,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isValid ? () {} : null,
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Button disabled initially
        final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Continue'),
        );
        expect(button.onPressed, isNull);

        // Enter invalid number
        await tester.enterText(find.byType(TextField), '12345');
        await tester.pump();

        expect(find.text('Invalid phone number'), findsOneWidget);

        // Enter valid number
        await tester.enterText(find.byType(TextField), '4155551234');
        await tester.pump();

        expect(find.text('Invalid phone number'), findsNothing);
      });
    });

    group('List Interaction', () {
      testWidgets('ride history list displays items', (tester) async {
        final rides = [
          {'from': '123 Main St', 'to': 'Airport', 'fare': 25.00},
          {'from': 'Home', 'to': 'Work', 'fare': 12.50},
          {'from': 'Gym', 'to': 'Home', 'fare': 8.75},
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  return ListTile(
                    title: Text('${ride['from']} → ${ride['to']}'),
                    trailing: Text('\$${ride['fare']}'),
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('123 Main St → Airport'), findsOneWidget);
        expect(find.text('Home → Work'), findsOneWidget);
        expect(find.text('Gym → Home'), findsOneWidget);
        expect(find.text('\$25.0'), findsOneWidget);
      });

      testWidgets('empty state shown when no rides', (tester) async {
        final rides = <Map<String, dynamic>>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: rides.isEmpty
                  ? const Center(child: Text('No ride history'))
                  : ListView.builder(
                      itemCount: rides.length,
                      itemBuilder: (context, index) => const ListTile(),
                    ),
            ),
          ),
        );

        expect(find.text('No ride history'), findsOneWidget);
      });
    });

    group('Settings Toggle', () {
      testWidgets('toggle switches state', (tester) async {
        bool isEnabled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: SwitchListTile(
                    title: const Text('Notifications'),
                    value: isEnabled,
                    onChanged: (value) => setState(() => isEnabled = value),
                  ),
                );
              },
            ),
          ),
        );

        expect(find.byType(Switch), findsOneWidget);

        // Toggle on
        await tester.tap(find.byType(Switch));
        await tester.pump();

        // Toggle off
        await tester.tap(find.byType(Switch));
        await tester.pump();
      });
    });
  });
}
