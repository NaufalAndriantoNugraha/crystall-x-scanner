import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart' as barcode;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:scan_qr_member/components/custom_dialog.dart';

enum DialogType { success, error }

class ScannerScreen extends StatefulWidget {
  static const String routeName = '/scanner_screen';

  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 300), () {
    //   _scanQRCode();
    // });
    _scanQRCode();
  }

  Future<void> _scanQRCode() async {
    try {
      final result = await barcode.BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        await scanQR(result.rawContent);
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future scanQR(String qrcode) async {
    Position? position = await _getCurrentLocation();

    try {
      if (position != null) {
        Map<String, String> request = {
          'product_id': qrcode,
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };

        const linkUrl = "https://indoraya.rajaqr.com/api/scan_qr";
        Uri uri = Uri.parse(linkUrl);

        var response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(request),
        );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);

          String productName = jsonResponse['data']['product_name'] ?? 'N/A';
          String serialNumber = jsonResponse['data']['serial_number'] ?? 'N/A';
          String packagingDate =
              jsonResponse['data']['packaging_date'] ?? 'N/A';
          String activePeriod = jsonResponse['data']['active_period'] ?? 'N/A';
          String textScan = jsonResponse['data']['text'] ?? 'N/A';

          _showDialogFormat(
            'Success',
            productName,
            serialNumber,
            DateTime.parse(packagingDate),
            DateTime.parse(activePeriod),
            textScan,
            DialogType.success,
          );
        } else {
          _showDialog(
            'Error',
            'Produk sudah mencapai batas maksimal scan.',
            DialogType.error,
          );
        }
      } else {
        _showDialog(
          'Error',
          'Tidak dapat memperoleh lokasi.',
          DialogType.error,
        );
      }
    } catch (e) {
      _showDialog(
        'Error',
        'Terjadi kesalahan pada sistem, coba lagi nanti!',
        DialogType.error,
      );
    }
  }

  // void _showDialog(String title, String description, DialogType type) {
  //   AwesomeDialog(
  //     context: context,
  //     animType: AnimType.leftSlide,
  //     headerAnimationLoop: false,
  //     dialogType: type,
  //     showCloseIcon: true,
  //     title: title,
  //     dismissOnTouchOutside: false,
  //     desc: description,
  //     btnOkOnPress: () {
  //       _scanQRCode();
  //     },
  //     btnCancelOnPress: () {
  //       Navigator.of(context).pop();
  //     },
  //     btnOkText: "OK",
  //     btnCancelText: "Cancel",
  //     btnOkIcon: Icons.check_circle,
  //     btnCancelIcon: Icons.cancel,
  //   ).show();
  // }

  void _showDialog(String title, String description, DialogType type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          type: type,
          title: title,
          description: description,
          isFormatted: false,
          onOk: () {
            Navigator.of(context).pop();
            _scanQRCode();
          },
          onCancel: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<Position?> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  // void _showDialogFormat(
  //   String title,
  //   String productName,
  //   String serialNumber,
  //   DateTime packagingDate,
  //   DateTime activePeriod,
  //   String textScan,
  //   DialogType type,
  // ) {
  //   String formattedPackagingDate = DateFormat(
  //     'yyyy-M-d',
  //   ).format(packagingDate);
  //   String formattedActivePeriod = DateFormat('yyyy-M-d').format(activePeriod);

  //   AwesomeDialog(
  //     context: context,
  //     animType: AnimType.leftSlide,
  //     headerAnimationLoop: false,
  //     dialogType: type,
  //     showCloseIcon: true,
  //     title: title,
  //     dismissOnTouchOutside: false,
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Nama Produk: $productName', textAlign: TextAlign.start),
  //         Text('Nomor Seri: $serialNumber', textAlign: TextAlign.start),
  //         Text(
  //           'Tanggal Pengemasan: $formattedPackagingDate',
  //           textAlign: TextAlign.start,
  //         ),
  //         Text(
  //           'Masa Berlaku: $formattedActivePeriod',
  //           textAlign: TextAlign.start,
  //         ),
  //         const SizedBox(height: 16),
  //         Text('Scan: $textScan', textAlign: TextAlign.start),
  //       ],
  //     ),
  //     btnOkOnPress: () {
  //       _scanQRCode();
  //     },
  //     btnCancelOnPress: () {
  //       Navigator.of(context).pop();
  //     },
  //     btnOkText: "OK",
  //     btnCancelText: "Cancel",
  //     btnOkIcon: Icons.check_circle,
  //     btnCancelIcon: Icons.cancel,
  //   ).show();
  // }

  void _showDialogFormat(
    String title,
    String productName,
    String serialNumber,
    DateTime packagingDate,
    DateTime activePeriod,
    String textScan,
    DialogType type,
  ) {
    String formattedPackagingDate = DateFormat(
      'yyyy-M-d',
    ).format(packagingDate);
    String formattedActivePeriod = DateFormat('yyyy-M-d').format(activePeriod);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          type: type,
          title: title,
          isFormatted: true,
          productName: productName,
          serialNumber: serialNumber,
          formattedPackagingDate: formattedPackagingDate,
          formattedActivePeriod: formattedActivePeriod,
          textScan: textScan,
          onOk: () {
            Navigator.of(context).pop();
            _scanQRCode();
          },
          onCancel: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

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
      ),
    );
  }
}
