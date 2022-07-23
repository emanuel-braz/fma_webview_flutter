### [fma_webview_flutter](https://pub.dev/packages/fma_webview_flutter) enables the web applications, a bilateral communication to Flutter code (Dart) or Native code (Kotlin / Swift) using the package [flutter_micro_app](https://pub.dev/packages/flutter_micro_app) and [webview_flutter](https://pub.dev/packages/webview_flutter).

>This package is intended to be used with the [flutter_micro_app](https://pub.dev/packages/flutter_micro_app) package. Please read about the micro events from flutter_micro_app package doc.
#### Use the `WebviewRegisterControllerMixin` mixin in order to get the method `registerWebviewController` and get the webview controller `webviewController`.

```dart
class _MyWebviewState extends State<MyWebviewWidget> with WebviewRegisterControllerMixin {

  @override
  Widget build(BuildContext context) {
    return WebView(  
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
            
            //! IMPORTANT: Register the controller
            registerWebviewController(
                controller,
                name: 'Micro Webview App',
                description: 'Dispatch event to/from webview',
            );
        },

        //! IMPORTANT: Set the channel
        javascriptChannels: <JavascriptChannel>{microWebviewController.channel},
    );
  }
}
```


```dart
// later
webviewController?.loadUrl("http://...");
```

### On the web application side, import the javascript file `flutter_micro_app.js`
```html
<!-- html -->
<script src="./flutter_micro_app.js"></script>
```

#### Dispatching micro events to Flutter or native (it depends on flutter/native implementation)
```javascript
// javascript
var requestBatteryLevelEvent =  JSON.stringify(
    {
        name: 'request_battery_level',
        channels: ['request_battery_level'],
    }
);

FlutterMicroApp.emit(requestBatteryLevelEvent)
```

#### Listening to micro events channels
```javascript
// javascript
FlutterMicroApp.listen("response_battery_level", function(microAppEvent) {
    alert("Battery level is " + microAppEvent.payload + "%")
});
```
<img src="https://user-images.githubusercontent.com/3827308/180587584-e1b4cea3-c92d-45b6-91bc-dbb5e1e74487.png" width="250" />

#### (Optional) If you intended to return a result from Javascript to flutter or native, please override this function
>This is the method that will be called by the Flutter app
and will be used to return a value to the Flutter app.
You should overwrite it, in order to respond the event with some value.

```javascript
// javascript example
MicroAppEventController.handleFlutterMicroAppEvent = (microAppEvent) => {
    return `************** ${microAppEvent.payload} received on JS ***************`
}
```
