import 'package:flutter/material.dart';

class SnapSyncApp extends StatelessWidget {
  const SnapSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2F4FE0)),
      home: const Scaffold(
        body: Center(child: Text('SnapSync')),
      ),
    );
  }
}
