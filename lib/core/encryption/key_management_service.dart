import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyManagementService {
  static const _keyStorageKey = 'notepad_encryption_key';
  final _secureStorage = const FlutterSecureStorage();
  final _algorithm = AesGcm.with256bits();

  Future<SecretKey> getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyStorageKey);
    if (existing != null) {
      final bytes = base64Decode(existing);
      return SecretKey(bytes);
    }

    final newKey = await _algorithm.newSecretKey();
    final bytes = await newKey.extractBytes();
    await _secureStorage.write(key: _keyStorageKey, value: base64Encode(bytes));
    return newKey;
  }
}