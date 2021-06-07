import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_ffii_static_link_issue/dart_ffii_static_link_issue.dart';

void main() {
  const MethodChannel channel = MethodChannel('dart_ffii_static_link_issue');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DartFfiiStaticLinkIssue.platformVersion, '42');
  });
}
