import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tickly/main.dart';
import 'package:tickly/src/core/extensions/aes_cipher.dart';
import 'package:tickly/src/core/logger/logger.dart';

class DeviceId {
  static String _uniqueDeviceId = '';

  static Future<String> getUniqueDeviceId() async {
    if (_uniqueDeviceId.isNotEmpty) {
      logger.d('Returning cached device ID: $_uniqueDeviceId');
    }

    // Implement your logic to retrieve the unique device ID here
    // For example, you can use the device_info_plus package to get device information

    // Example:
    // final deviceInfo = DeviceInfoPlugin();
    // final androidInfo = await deviceInfo.androidInfo;
    // _uniqueDeviceId = androidInfo.androidId ?? '';

    return _uniqueDeviceId;
  }

  static String _readAndroidDeviceInfo(AndroidDeviceInfo data) {
    // Implement your logic to read Android device information here
    // For example, you can use the androidId property
    return data.version.release +
        data.version.previewSdkInt.toString() +
        data.version.incremental +
        data.version.codename +
        data.brand +
        data.device +
        data.host +
        data.id +
        data.model +
        data.supportedAbis.toString(); // Example implementation
  }

  static String _readIosDeviceInfo(IosDeviceInfo data) {
    return data.name +
        data.systemName +
        data.systemVersion +
        data.model +
        data.localizedModel +
        data.identifierForVendor.toString() +
        data.isPhysicalDevice.toString() +
        data.utsname.sysname +
        data.utsname.nodename +
        data.utsname.release +
        data.utsname.version +
        data.utsname.machine;
  }

  static Future<void> setupUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    var uniqueDeviceId = "";

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = _readIosDeviceInfo(
        iosDeviceInfo,
      ).toString(); // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = _readAndroidDeviceInfo(androidDeviceInfo);
    }

    if (!isInitializedFirebase) {
      // await initFirebase();
      return;
    }

    var key = await FirebaseMessaging.instance.getToken();
    final cipher = AESCipher(key!);

    _uniqueDeviceId = cipher.encryptText(uniqueDeviceId);

    logger.d("uniqueDeviceId: $_uniqueDeviceId");
  }
}
