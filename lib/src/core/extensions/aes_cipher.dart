import 'package:encrypt/encrypt.dart';

import '../../constants/environment.dart';

class AESCipher {
  static String get iVUtf8 => Environment.getIVUtf8;

  final Key key;
  final IV iv;
  final Encrypter encrypter;

  AESCipher(String keyStr)
      : key = Key.fromUtf8(_normalizeKey(keyStr)),
        iv = IV.fromUtf8(iVUtf8),
        encrypter = Encrypter(AES(Key.fromUtf8(_normalizeKey(keyStr))));

  static String _normalizeKey(String keyStr) {
    if (keyStr.length >= 32) return keyStr.substring(0, 32);
    return keyStr.padRight(32, '0');
  }

  String encryptText(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptText(String base64Text) {
    return encrypter.decrypt64(base64Text, iv: iv);
  }
}
