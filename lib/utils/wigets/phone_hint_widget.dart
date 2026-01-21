import 'package:flutter/services.dart';

class PhoneHintHelper {
  static const platform = MethodChannel('com.example.phonehint/channel');

  static Future<String?> requestPhoneHint() async {
    try {
      final String? phoneNumber = await platform.invokeMethod('requestPhoneHint');
      return phoneNumber;
    } on PlatformException catch (e) {
      print("Failed to get phone hint: '${e.message}'");
      return null;
    }
  }
}

// Usage:
// final phoneNumber = await PhoneHintHelper.requestPhoneHint();