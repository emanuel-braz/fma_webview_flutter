import 'package:flutter/widgets.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../fma_webview_flutter.dart';

mixin WebviewRegisterControllerMixin<T extends StatefulWidget> on State<T> {
  late WebviewFlutterMicroEventController _microWebviewController;

  @override
  initState() {
    _microWebviewController = WebviewFlutterMicroEventController();
    super.initState();
  }

  WebviewFlutterMicroEventController get microWebviewController =>
      _microWebviewController;
  String? controllerId;

  registerWebviewController(WebViewController webViewController) {
    if (controllerId != null) {
      throw Exception(
          'It is not allowed to register more than one controller for the same widget');
    }

    controllerId = '${_microWebviewController.hashCode ^ hashCode}';

    _microWebviewController.setController(webViewController);
    MicroAppEventController().registerWebviewController(
      id: controllerId!,
      controller: _microWebviewController,
    );
  }

  void _unregisterEventHandlers() {
    if (controllerId == null) return;
    MicroAppEventController().unregisterWebviewController(id: controllerId!);
  }

  @override
  void dispose() {
    _unregisterEventHandlers();
    super.dispose();
  }
}
