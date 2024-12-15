import 'package:flutter/material.dart';
import 'package:events/secondpage.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light, // Light theme by default
      ),
      home: Homepage(),
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<DateTime, String> _listTask = {};
  Map<DateTime, bool> _taskCompletion = {};

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = '${today.day}-${today.month}-${today.year}'; // Format the current date
    final sortedKeys = _listTask.keys.toList()..sort();

    void _showTaskDialog(BuildContext context, DateTime dateTime) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Task Options'),
            content: const Text('Mark this task as completed?'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _taskCompletion[dateTime] = true; // Mark as completed
                  });
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Task Completed'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _taskCompletion[dateTime] = false; // Mark as completed
                  });
                  Navigator.pop(context); // Close the dialog without changes
                },
                child: const Text('Not Completed'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Event Schedule', style: TextStyle(fontSize: 18)),
            Text(
              'Today: $formattedDate',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        centerTitle: true,
        leading: const Icon(Icons.bookmark, color: Colors.white),
      ),
      body: _listTask.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0), // Add padding around the list
        itemCount: _listTask.length,
        itemBuilder: (context, index) {
          final dateTime = sortedKeys[index]; // Use the sorted key
          final task = _listTask[dateTime];
          final isCompleted = _taskCompletion[dateTime] ?? false;
          List months =
          ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

          return Card(
            elevation: 4,
            color: isCompleted ? Colors.teal[100] : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  '${dateTime.year}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              subtitle: Text(
                task!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              title: Text(
                '${dateTime.day}-${months[dateTime.month-1]}-${dateTime.year}     ${dateTime.hour}:${dateTime.minute}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                ),
              ),
              onLongPress: () {
                _showTaskDialog(context, dateTime);
              },
              trailing: isCompleted
                  ? const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
              )
                  : const Icon(
                Icons.radio_button_unchecked_rounded,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const addtask()),
          );
          if (data != null && data is Map<DateTime, String>) {
            setState(() {
              _listTask.addAll(data);
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}