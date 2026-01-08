import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';


class ScheduleAheadScreen extends StatefulWidget{
  
  @override
  State<ScheduleAheadScreen> createState() => _ScheduleAheadScreenState();
}

class _ScheduleAheadScreenState extends State<ScheduleAheadScreen>{
  DateTime? datter = DateTime.now();

  void _confirmTime() {
    Navigator.pop(context, datter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomHeader(title: 'Schedule a ride'),
            const SizedBox(height: 36),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))
              ),
              child: Text(
                'Depart',
                style: TextStyle(color: Colors.white, fontSize: 16)
              )
            ),
            SizedBox(
              height: 250,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
                child:CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(const Duration(days: 90)),
                  use24hFormat: false,
                  initialDateTime: datter!.add(const Duration(minutes: 1)),
                  onDateTimeChanged: (dt) => setState(() => datter = dt)
                )
              )
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _confirmTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(120)
                  )
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)
                )
              )
            ),
            ]
          )
        )
      )
    );
  }
}