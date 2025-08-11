import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routing/app_pages.dart';
import '../../widgets/button.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final InAppWebViewController? preloadedController;

  const WebViewScreen({
    Key? key,
    this.preloadedController,
    required this.url,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    webViewController = widget.preloadedController;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (await webViewController?.canGoBack() ?? false) {
            webViewController?.goBack();
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                content: const Text('Do you want to exit from the app?'),
                actions: [
                  CustomElevatedBtn(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    text: 'Yes',
                  ),
                  CustomTextBtn(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog
                    },
                    text: 'No',
                  )
                ],
              ),
            );
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.url),
                ),
                initialSettings: InAppWebViewSettings(
                  supportZoom: false,
                  javaScriptEnabled: true,
                  useWideViewPort: true,
                  loadWithOverviewMode: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                  webviewJavaScriptHandlers(controller, context);
                },
                onLoadStart: (controller, url) {
                  setState(() => isLoading = true);
                },
                onLoadStop: (controller, url) async {
                  setState(() => isLoading = false);
                  final currentUrl = url?.toString() ?? '';

                  if (currentUrl == 'https://shop.oklifecare.com/' ||
                      currentUrl == 'https://shop.oklifecare.com') {
                    await Future.delayed(Duration(milliseconds: 300));
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/loginmemeber', (route) => false);
                    }
                    return;
                  }

                  await controller.evaluateJavascript(source: '''
                  var logoutLink = document.querySelector('a[href="logout.aspx"]');
                  if (logoutLink) {
                    logoutLink.addEventListener('click', function(event) {
                      event.preventDefault();
                      window.flutter_inappwebview.callHandler('logoutHandler');
                    });
                  }
                ''');

                  await controller.evaluateJavascript(source: '''
                  var existing = document.querySelector('meta[name=viewport]');
                  if (!existing) {
                    var meta = document.createElement('meta');
                    meta.name = 'viewport';
                    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                    document.head.appendChild(meta);
                  } else {
                    existing.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                  }
                ''');
                },
                onDownloadStartRequest: (controller, url) async {
                  await controller.evaluateJavascript(
                    source: blobToBinaryJsCode.replaceAll(
                      "blobUrlPlaceholder",
                      url.url.toString(),
                    ),
                  );
                },
              ),
              if (isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text("Please wait..."),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> _onWillPop() async {
    if (await webViewController?.canGoBack() ?? false) {
      webViewController?.goBack();
      return false;
    } else {
      return true;
    }
  }

  final String blobToBinaryJsCode = r"""
    var xhr = new XMLHttpRequest();
    var blobUrl = "blobUrlPlaceholder";
    xhr.open('GET', blobUrl, true);
    xhr.responseType = 'blob';
    xhr.onload = function(e) {
        if (this.status == 200) {
            var blob = this.response;
            var reader = new FileReader();
            reader.readAsDataURL(blob);
            reader.onloadend = function() {
                var base64data = reader.result.split(',')[1];
                var mimeType = blob.type;
                window.flutter_inappwebview.callHandler('blobToBinaryHandler', base64data, mimeType);
            };
        }
    };
    xhr.send();
  """;

  void webviewJavaScriptHandlers(InAppWebViewController controller, BuildContext context) {
    // ✅ File Blob Handler
    controller.addJavaScriptHandler(
      handlerName: 'blobToBinaryHandler',
      callback: (data) async {
        if (data.isNotEmpty) {
          final String byteString = data[0];
          final String receivedMimeType = data[1];
          final String yourExtension = _mapMimeTypeToYourExtension(receivedMimeType);

          if (byteString.isNotEmpty && yourExtension.isNotEmpty) {
            await _createFileFromBytes(
              byteString,
              'downloaded_file_${DateTime.now().microsecondsSinceEpoch}.$yourExtension',
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid binary data or MIME type.')),
            );
          }
        }
      },
    );

    // ✅ Logout Handler
// ✅ Logout Handler using GoRouter
    controller.addJavaScriptHandler(
      handlerName: 'logoutHandler',
      callback: (args) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (context.mounted) {
          context.goNamed(AppPages.loginmemeber); // ✅ <-- GoRouter navigation
        }
      },
    );

  }

  String _mapMimeTypeToYourExtension(String mimeType) {
    if (mimeType.startsWith('image/')) return mimeType.split('/').last;
    if (mimeType == 'application/pdf') return 'pdf';
    if (mimeType == 'text/plain') return 'txt';
    return 'bin';
  }

  Future<void> _createFileFromBytes(String byteString, String fileName) async {
    try {
      await _requestPermissions();
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
      if (directory != null) {
        final path = '${directory.path}/$fileName';
        final file = File(path);
        final bytes = base64Decode(byteString);
        await file.writeAsBytes(bytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File downloaded successfully.'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                final result = await OpenFile.open(file.path);
                if (result.type != ResultType.done) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error opening file.')),
                  );
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.accessMediaLocation,
    ];
    for (var permission in permissions) {
      if (await permission.status.isDenied) {
        await permission.request();
      }
    }
  }
}
