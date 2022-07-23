import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'src/simple_webview.dart';

void main() {
  MicroAppPreferences.update(
    MicroAppConfig(nativeEventsEnabled: Platform.isAndroid),
  );

  runApp(MyApp());
}

class MyApp extends MicroHostStatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Micro Web Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      onGenerateRoute: onGenerateRoute,
      navigatorKey: NavigatorInstance.navigatorKey,
    );
  }

  @override
  List<MicroApp> get initialMicroApps => [];

  @override
  List<MicroAppPage<Widget>> get pages => [
        MicroAppPage<SimpleWebview>(
          route: 'webview',
          pageBuilder: PageBuilder(
            builder: (_, __) => const SimpleWebview(),
          ),
          description: 'Webview Demo Page',
        ),
      ];
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
    MicroBoard.showButton();

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
            context.maNav.pushNamed('webview');
          },
          child: const Text('Open Webview'),
        ),
      ),
    );
  }
}
