import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aliplayer_artc/flutter_aliplayer_artc.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aliplayer_artc');

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
    expect(await FlutterAliplayerArtc.platformVersion, '42');
  });
}
