import 'dart:async';

import 'package:hive_ce_flutter/adapters.dart';

import 'package:tickly/src/core/extensions/device_id.dart';

import '../../local_storage/app_local_storage.dart';
// import '../../notification/FirebaseMessage.dart';

class HiveProvider {
  static Future<Box> openNotiBox() async {
    if (!await Hive.boxExists('notifications')) {
      await Hive.openBox('notifications');
    }
    if (!Hive.isBoxOpen('notifications')) {
      await Hive.openBox('notifications');
    }
    return Hive.box('notifications');
  }

  static void addNotification() async {
    var notiBox = await openNotiBox();
    if (!notiBox.containsKey('unReadNotiCount')) {
      notiBox.put('unReadNotiCount', 1);
    } else {
      notiBox.put('unReadNotiCount', notiBox.get('unReadNotiCount') + 1);
    }
  }

  static void subtractNotification() async {
    var notiBox = await openNotiBox();
    if (!notiBox.containsKey('unReadNotiCount')) {
      notiBox.put('unReadNotiCount', 0);
    } else {
      notiBox.put(
        'unReadNotiCount',
        notiBox.get('unReadNotiCount') != 0
            ? notiBox.get('unReadNotiCount') - 1
            : 0,
      );
    }
  }

  static void clearAllNotification() async {
    var notiBox = await openNotiBox();
    notiBox.put('unReadNotiCount', 0);
  }

  static void initNotification(int count) async {
    var notiBox = await openNotiBox();
    notiBox.put('unReadNotiCount', count);
  }

  // static Future<void> clearToken(VoidCallback callback) async {
  //   AppDialog.showLoadingDialog(message: 'Logging out');
  //   // await FirebaseMessage().deleteFCMToken();
  //   await DeviceId.setupUniqueDeviceId();
  //   Hive.deleteFromDisk().then((_) {
  //     AppLocalStorage().initLocalStorage();

  //     Timer(const Duration(seconds: 1), () {
  //       AppDialog.closeDialog();
  //       callback();
  //     });
  //   });
  // }
}
