import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Opens a document with the device's default viewer.
///
/// `open_file` only handles local paths, so a remote URL is downloaded to a
/// temporary file first; a local file path is opened directly.
class FileOpener {
  FileOpener._();

  static final Dio _dio = Dio();

  /// Opens [value] — a local file path or a remote http(s) URL.
  static Future<void> open(String value) async {
    if (value.isEmpty) return;
    var path = value;
    if (value.startsWith('http')) {
      final dir = await getTemporaryDirectory();
      final raw = value.split('?').first.split(RegExp(r'[/\\]')).last;
      final name = raw.isEmpty ? 'document' : raw;
      path = '${dir.path}/$name';
      await _dio.download(value, path);
    }
    await OpenFile.open(path);
  }
}
