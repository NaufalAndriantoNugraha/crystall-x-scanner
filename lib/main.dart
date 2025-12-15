import 'package:flutter/material.dart';
import 'package:scan_qr_member/screens/main_screen.dart';
import 'package:scan_qr_member/screens/scanner_screen.dart';
import 'package:scan_qr_member/styles/custom_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crystall-X Scanner',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      initialRoute: MainScreen.routeName,
      routes: {
        MainScreen.routeName: (context) => MainScreen(),
        ScannerScreen.routeName: (context) => ScannerScreen(),
      },
    );
  }
}
