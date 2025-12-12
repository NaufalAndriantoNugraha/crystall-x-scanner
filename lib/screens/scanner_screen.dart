import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan_qr_member/components/scanner_corners_painter.dart';

class ScannerScreen extends StatefulWidget {
  static const String routeName = '/scanner_screen';

  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController mobileScannerController = MobileScannerController(
    torchEnabled: false,
  );

  bool isFlashOn = false;
  String barcodeResult = "Point the camera at a barcode";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Crystal-X Scanner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () async {
              await mobileScannerController.toggleTorch();
              setState(() {
                isFlashOn = !isFlashOn;
              });
            },
            child: Text(
              'FLASH ${isFlashOn ? 'OFF' : 'ON'}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: mobileScannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                setState(() {
                  barcodeResult = barcodes.first.rawValue!;
                });
              }
            },
          ),
          Center(
            child: Container(
              width: 320,
              height: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(painter: ScannerCornersPainter()),
            ),
          ),
          Center(child: Text(barcodeResult)),
        ],
      ),
    );
  }
}
