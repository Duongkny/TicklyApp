import 'dart:math';

import 'aes_cipher.dart';

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this);
  }

  String generateRandomString(int count) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()_+=-`~[]{}|;:",./<>?';
    Random rnd = Random();
    return this +
        String.fromCharCodes(Iterable.generate(
            count, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String capitalizeFirst() {
    return replaceFirst(this[0], this[0].toUpperCase());
  }

  String removeSpecialCharacters() {
    return replaceAll(RegExp(r"[^a-zA-Z0-9\s]"), "");
  }

  String encrypt({String key = "cipher_string_key"}) {
    try {
      final cipher = AESCipher(key);
      return cipher.encryptText(this);
    } catch (e) {
      return this;
    }
  }

  String decrypt({String key = "cipher_string_key"}) {
    try {
      final cipher = AESCipher(key);
      return cipher.decryptText(this);
    } catch (e) {
      return this;
    }
  }
}