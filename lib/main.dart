import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const SiaTuApp());
}

class SiaTuApp extends StatelessWidget {
  const SiaTuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIA-TU SEKOLAH',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}