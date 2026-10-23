import 'package:tickly/hive/hive_registrar.g.dart';

import '../logger/logger.dart';
import 'local_storage_key.dart';

import 'package:hive_ce_flutter/adapters.dart';


class AppLocalStorage {
  static String currentLanguageCode = "";
  static Box<dynamic> get localBox {
    if (!Hive.isBoxOpen(LocalStorageKey.localStorage)) {
      Hive.openBox(LocalStorageKey.localStorage);
    }
    return Hive.box(LocalStorageKey.localStorage);
  }

  static void create(Map data) {
    localBox.add(data);
  }

  static dynamic get(dynamic key) {
    return localBox.get(key);
  }

  static void update<E>(dynamic key, E data) {
    localBox.put(key, data);
  }

  static Future<void> delete(dynamic key) {
    return localBox.delete(key);
  }

  static String getNowTime() {
    return DateTime.now().toString();
  }

  static bool isRegisterAdapters = false;

  Future<void> initLocalStorage() async {
    await Hive.initFlutter();
    if (!isRegisterAdapters) {
      Hive.registerAdapters();
      isRegisterAdapters = true;
    }

    // Mở các box
    await Future.wait([
          Hive.openBox(LocalStorageKey.localStorage),
          Hive.openBox(LocalStorageKey.token),
        ])
        .then((_) {
          logger.d("Đã mở tất cả các box thành công");
        })
        .catchError((error) {
          logger.e("Lỗi khi mở box: $error");
        });
  }
}