import 'package:flutter/material.dart';
import '../widgets/add_shortcut_modal.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lyft')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Where To',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    print('Tapped!');
                  },
                  child: Text('Scedule Ahead'),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    addShortcutModal(context, 'Home', Icons.home);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      Column(
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Add shortcut', style: TextStyle(fontSize: 8)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    addShortcutModal(context, 'Work', Icons.work);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.work),
                      Column(
                        children: [
                          Text(
                            'Work',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Add shortcut', style: TextStyle(fontSize: 8)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'You Are Here',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text('Map will go here')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}