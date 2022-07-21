// ignore_for_file: unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_webview_flutter/fma_webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebview extends StatefulWidget {
  const SimpleWebview({Key? key}) : super(key: key);

  @override
  State<SimpleWebview> createState() => _SimpleWebviewState();
}

class _SimpleWebviewState extends State<SimpleWebview>
    with WebviewRegisterControllerMixin {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Micro Web'),
      ),
      body: WebView(
        initialUrl: "about:blank",
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;

          // this should be registered once
          //! IMPORTANT: Register the controller
          registerWebviewController(
            controller,
            name: 'Micro Webview Name',
            description: 'Dispatch event to/from webview',
          );

          _loadLocalHtmlFile();
          // _loadRemoteApp();
        },
        onPageFinished: (String url) {
          // print('Page finished loading: $url');
        },
        javascriptMode: JavascriptMode.unrestricted,

        //! IMPORTANT: Set the channel
        javascriptChannels: <JavascriptChannel>{microWebviewController.channel},
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final event = MicroAppEvent(
            name: 'from_flutter',
            channels: const ['flutter_js', 'multi-channel'],
            payload: "JS says: Hello from Flutter",
          );
          final result =
              await MicroAppEventController().emit(event).getFirstResult();
          // ignore: avoid_print
          print(result);
        },
        child: const Text('Send event to JS'),
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
    _controller.loadUrl("http://...");
  }

  _loadLocalHttpServer() async {
    _controller.loadUrl("http://localhost:8080");
  }
}
