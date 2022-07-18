import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:fma_webview_flutter/src/utils/consts/constants.dart' as consts;
import 'package:webview_flutter/webview_flutter.dart';

class WebviewFlutterMicroEventController
    extends GenericMicroAppEventController {
  WebViewController? _controller;
  WebViewController? get controller => _controller;
  bool get hasController => _controller != null;

  late JavascriptChannel _channel;
  JavascriptChannel get channel => _channel;

  void setController(WebViewController controller) {
    _controller = controller;
  }

  @override
  void dispose() {
    _controller = null;
  }

  WebviewFlutterMicroEventController()
      : super(methodChannel: Constants.flutterMicroAppEvent) {
    _channel = JavascriptChannel(
        name: Constants.flutterMicroAppEvent,
        onMessageReceived: (JavascriptMessage event) {
          onEvent(parseMicroEvent(event));
        });
  }

  @override
  Future<Object?> emit(Object event, {Duration? timeout}) async {
    if (_controller == null) return null;
    final future = _controller!.runJavascriptReturningResult(
        "${consts.Constants.onFlutterMicroAppEvent}('$event');");
    if (timeout != null) return future.timeout(timeout);
    return future;
  }

  MicroAppEvent? parseMicroEvent(JavascriptMessage event) {
    try {
      MicroAppEvent? microEvent = MicroAppEvent.fromJson(event.message);

      if (microEvent != null) {
        return microEvent.copyTyped();
      }
      return null;
    } catch (e) {
      logger.e('[WebviewFlutterController] Parse Error!', error: e);
      return null;
    }
  }
}
