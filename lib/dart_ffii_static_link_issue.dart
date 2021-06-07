import 'dart:async';

import 'package:dart_ffii_static_link_issue/src/pdf_renderer.dart';

import 'package:flutter/services.dart';

export 'package:dart_ffii_static_link_issue/src/pdf_renderer.dart';

class DartFfiiStaticLinkIssue {
  static const MethodChannel _channel =
      const MethodChannel('dart_ffii_static_link_issue');

  static Future<String?> get platformVersion async {
    checkPDFiumLink();
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void checkPDFiumLink() {
    final PdfRenderer renderer = PdfRenderer.load('libpdfium.cr.so');
  }
}
