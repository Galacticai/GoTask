import 'dart:convert';

import 'package:encrypt/encrypt.dart';

String decryptString(String keyString, String encryptedString) {
  return decrypt(keyString, Encrypted(utf8.encode(encryptedString)));
}

String decryptBase64(String keyString, String encryptedBase64) {
  return decrypt(keyString, Encrypted(base64.decode(encryptedBase64)));
}

String decrypt(String keyString, Encrypted encryptedData) {
  final keyString128 = keyString.substring(0, 16);
  final key = Key.fromUtf8(keyString128);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(keyString128);
  return encrypter.decrypt(encryptedData, iv: initVector);
}

String encryptToBase64(String keyString, String plainText) {
  return encrypt(keyString, plainText).base64;
}

Encrypted encrypt(String keyString, String plainText) {
  if (keyString.length < 16) {
    throw RangeError("Key length must be >=16 (>=128 bits)");
  }
  final keyString128 = keyString.substring(0, 16);
  final key = Key.fromUtf8(keyString128);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(keyString128);
  Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
  return encryptedData;
}
