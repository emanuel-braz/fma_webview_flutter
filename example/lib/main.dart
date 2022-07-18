import 'dart:io';

import 'package:example/src/simple_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HandlerRegisterStateMixin {
  @override
  void initState() {
    super.initState();

    registerEventHandler(MicroAppEventHandler<Map<String, dynamic>?>(
      (event) {
        final Map<String, dynamic>? map = event.cast();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            map?['message'],
          ),
        ));
      },
      channels: const ['conn_status_off'],
      distinct: false,
    ));

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Micro Web Demo"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return const SimpleWebview();
              }));
            },
            child: const Text('Open Webview')),
      ),
    );
  }
}
