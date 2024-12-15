import 'package:flutter/material.dart';

class addtask extends StatefulWidget {
  const addtask({super.key});

  @override
  State<addtask> createState() => _addtaskState();
}

class _addtaskState extends State<addtask> {
  Map<DateTime, String> data = {};
  String st = "";
  DateTime date = DateTime.now();
  final TextEditingController _dateTime = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickdate != null) {
      final TimeOfDay? picktime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picktime != null) {
        date = DateTime(
            pickdate.year, pickdate.month, pickdate.day, picktime.hour, picktime.minute);
        _dateTime.text =
        '${date.year}/${date.month}/${date.day}  ${date.hour}:${date.minute}';
      }
    }
  }

  @override
  void dispose() {
    _dateTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                st = value;
              },
              decoration: const InputDecoration(
                labelText: "Enter the task ",
                border: OutlineInputBorder(),
                filled: true, // Enables the background color
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 25), // Add space
            TextField(
                readOnly: true,
                controller: _dateTime,
                decoration: const InputDecoration(
                    labelText: 'Select Date and Time',
                    border: OutlineInputBorder(),
                    filled: true, // Enables the background color
                    fillColor: Colors.white70,
                    suffixIcon: Icon(Icons.calendar_today_rounded)),
                onTap: () {
                  _selectDate(context);
                }),
            const SizedBox(height: 20), // Add Space
            ElevatedButton(
              onPressed: () {
                setState(() {
                  data[date] = st;
                });
                Navigator.pop(context, data);
              },
              child: const Text("Save and add new Task"),
            ),
          ],
        ),
      ),
    );
  }
}