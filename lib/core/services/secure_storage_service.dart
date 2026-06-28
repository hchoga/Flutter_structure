import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _namespace = 'app';
  final int _maxKeyLength = 128;
  final int _maxValueBytes = 65536;
  final List<int> _hmacKey;

  SecureStorageServiceImpl._({required List<int> hmacKey})
      : _hmacKey = hmacKey;

  static Future<SecureStorageServiceImpl> create() async {
    final hmacKey = await _deriveHmacKey();
    return SecureStorageServiceImpl._(hmacKey: hmacKey);
  }

  static Future<List<int>> _deriveHmacKey() async {
    final deviceId = await _getDeviceId();
    return sha256.convert(utf8.encode(deviceId)).bytes;
  }

  static Future<String> _getDeviceId() async {
    final info = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final android = await info.androidInfo;
        final id = android.id;
        return id.isNotEmpty ? id : _androidFallbackId(android);
      } else if (Platform.isIOS) {
        final ios = await info.iosInfo;
        return ios.identifierForVendor ?? _iosFallbackId(ios);
      }
    } catch (_) {
      // Device info unavailable — fall through to generic fallback.
    }

    return _genericFallbackId(await info.deviceInfo);
  }

  static String _androidFallbackId(AndroidDeviceInfo d) =>
      '${d.brand}-${d.model}-${d.fingerprint}';

  static String _iosFallbackId(IosDeviceInfo d) =>
      '${d.name}-${d.model}-${d.systemVersion}';

  static String _genericFallbackId(BaseDeviceInfo d) =>
      d.data.values.whereType<String>().join('-');

  // ── key / value guards ──────────────────────────────────────────────────────

  String _namespacedKey(String key) => '$_namespace:$key';

  void _validateKey(String key) {
    if (key.isEmpty) throw ArgumentError('Key must not be empty');
    if (key.length > _maxKeyLength) {
      throw ArgumentError('Key exceeds max length of $_maxKeyLength');
    }
    if (key.contains(RegExp(r'[/\\<>"\x00-\x1F]'))) {
      throw ArgumentError('Key contains disallowed characters');
    }
  }

  void _validateValue(String value) {
    if (utf8.encode(value).length > _maxValueBytes) {
      throw ArgumentError('Value exceeds max size of $_maxValueBytes bytes');
    }
  }

  // ── HMAC helpers ────────────────────────────────────────────────────────────

  String _sign(String namespacedKey, String value) {
    final payload = '$namespacedKey|$value';
    return Hmac(sha256, _hmacKey).convert(utf8.encode(payload)).toString();
  }

  String _pack(String namespacedKey, String value) {
    final mac = _sign(namespacedKey, value);
    return '$mac:$value';
  }

  String _unpack(String namespacedKey, String raw) {
    final idx = raw.indexOf(':');
    if (idx < 0) throw StateError('Stored value has no integrity marker');

    final storedMac = raw.substring(0, idx);
    final value = raw.substring(idx + 1);

    if (!_constantTimeEqual(storedMac, _sign(namespacedKey, value))) {
      throw StateError(
        'Integrity check failed — value may have been tampered with',
      );
    }
    return value;
  }

  bool _constantTimeEqual(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  // ── public API ───────────────────────────────────────────────────────────────

  @override
  Future<void> write({required String key, required String value}) async {
    _validateKey(key);
    _validateValue(value);
    final nsKey = _namespacedKey(key);
    await _storage.write(key: nsKey, value: _pack(nsKey, value));
  }

  @override
  Future<String?> read({required String key}) async {
    _validateKey(key);
    final nsKey = _namespacedKey(key);
    final raw = await _storage.read(key: nsKey);
    if (raw == null) return null;
    return _unpack(nsKey, raw);
  }

  @override
  Future<void> delete({required String key}) async {
    _validateKey(key);
    await _storage.delete(key: _namespacedKey(key));
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}