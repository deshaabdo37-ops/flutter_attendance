import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecordsScreen extends StatefulWidget {
  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List records = [];

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('attendance_records');
    if (savedData != null) {
      setState(() {
        records = jsonDecode(savedData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيلات الحضور')),
      body: records.isEmpty
          ? const Center(child: Text('لا توجد تسجيلات بعد'))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(record['data'] ?? 'غير معروف'),
                  subtitle: Text('الوقت: ${record['time']}'),
                );
              },
            ),
    );
  }
}
