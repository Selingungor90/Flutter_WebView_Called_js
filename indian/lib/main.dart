import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: SimpleWebview(),
    );
  }
}

class SimpleWebview extends StatefulWidget {
  @override
  _SimpleWebviewState createState() => _SimpleWebviewState();
}

class _SimpleWebviewState extends State<SimpleWebview> {
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView deneme"),
      ),
      body: _buildWebView(),
/*       floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.evaluateJavascript(
              'changeImagePathWith("Add your image path here");');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ), */
    );
  }

  Widget _buildWebView() {
    return WebView(
      initialUrl: "about:blank",
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
        _loadLocalHtmlFile();
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>[
        _messageJavascriptChannel(context),
        _scriptJavascriptChannel(context),
      ].toSet(),
    );
  }

  JavascriptChannel _messageJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        });
  }

  JavascriptChannel _scriptJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Postascript',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print(message.message);
        });
  }

  _loadLocalHtmlFile() async {
    String fileText = await rootBundle.loadString('assets/web/start.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
