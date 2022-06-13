import 'dart:io';

import 'package:example/src/simple_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

void main() {
  MicroAppPreferences.update(MicroAppConfig(
    nativeEventsEnabled: Platform.isAndroid,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Micro App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimpleWebview(),
    );
  }
}
