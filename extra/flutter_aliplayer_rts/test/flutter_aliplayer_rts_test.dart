import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aliplayer_rts/flutter_aliplayer_rts.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aliplayer_rts');

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
    expect(await FlutterAliplayerRts.platformVersion, '42');
  });
}
