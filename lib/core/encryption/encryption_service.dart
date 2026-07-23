import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'key_management_service.dart';

class EncryptionService {
  final KeyManagementService _keyService;
  final _algorithm = AesGcm.with256bits();

  EncryptionService(this._keyService);

  /// Encrypts [plaintext] and returns a single base64 string containing
  /// nonce + ciphertext + MAC, safe to store as a plain string field.
  Future<String> encrypt(String plaintext) async {
    final key = await _keyService.getOrCreateKey();
    final secretBox = await _algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: key,
    );
    return base64Encode(secretBox.concatenation());
  }

  /// Decrypts a string produced by [encrypt].
  Future<String> decrypt(String encoded) async {
    final key = await _keyService.getOrCreateKey();
    final bytes = base64Decode(encoded);
    final secretBox = SecretBox.fromConcatenation(
      bytes,
      nonceLength: _algorithm.nonceLength,
      macLength: _algorithm.macAlgorithm.macLength,
    );
    final decrypted = await _algorithm.decrypt(secretBox, secretKey: key);
    return utf8.decode(decrypted);
  }
}