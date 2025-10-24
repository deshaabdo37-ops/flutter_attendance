import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'records_screen.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanned = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!scanned) {
        scanned = true;
        controller.pauseCamera();

        final data = scanData.code ?? '';
        final now = DateTime.now();
        final record = {
          'data': data,
          'time': now.toString(),
        };

        final prefs = await SharedPreferences.getInstance();
        final savedData = prefs.getString('attendance_records');
        List records = savedData != null ? jsonDecode(savedData) : [];
        records.add(record);
        await prefs.setString('attendance_records', jsonEncode(records));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تسجيل الحضور بنجاح')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RecordsScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مسح كود QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
