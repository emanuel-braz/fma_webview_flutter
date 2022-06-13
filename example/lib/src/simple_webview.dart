import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_webview_flutter/fma_webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebview extends StatefulWidget {
  const SimpleWebview({Key? key}) : super(key: key);

  @override
  _SimpleWebviewState createState() => _SimpleWebviewState();
}

class _SimpleWebviewState extends State<SimpleWebview>
    with HandlerRegisterMixin {
  late WebViewController _controller;
  final _webviewFlutterMicroEventController =
      WebviewFlutterMicroEventController();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  List<MicroAppEventHandler> get eventHandlers => [
        MicroAppEventHandler<Map<String, dynamic>?>(
          (event) {
            final map = event.cast();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                map?['message'],
              ),
            ));
          },
          channels: const ['conn_status_off'],
          distinct: false,
        ),
        MicroAppEventHandler<String?>(
          (event) {
            String? message = event.cast();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message ?? 'unknown'),
            ));
          },
          distinct: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Micro Web Demo"),
      ),
      body: WebView(
          initialUrl: "about:blank",
          onWebViewCreated: (WebViewController controller) {
            _controller = controller;
            _webviewFlutterMicroEventController.setController(controller);
            // _loadLocalHtmlFile();
            _loadRemoteApp();
          },
          onPageFinished: (String url) {
            // print('Page finished loading: $url');
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: <JavascriptChannel>{
            _webviewFlutterMicroEventController.channel
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final event = MicroAppEvent(
            name: 'from_js',
            channels: const ['flutter_js', 'multi-channel'],
            payload: const {"status": "online"},
          );
          _webviewFlutterMicroEventController.emit(event.toJson());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  _loadLocalHtmlFile() async {
    String fileText = await rootBundle.loadString('assets/web/index.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _loadRemoteApp() async {
    _controller.loadUrl("http://192.168.0.28:8080");
  }
}
