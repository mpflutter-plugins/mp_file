part of 'mp_file.dart';

class PBFileManager extends FileManager {
  final _channel = MethodChannel('file_manager/mp');

  @override
  Future<Directory> appBundleDirectory() async {
    final result = _channel.invokeMethod('appBundleDirectory') as String;
    return Directory(result);
  }

  @override
  Future<Directory> appSandboxDirectory() async {
    final result = _channel.invokeMethod('appSandboxDirectory') as String;
    return Directory(result);
  }

  @override
  Future<File> copy(File file, String newPath) async {
    await _channel.invokeMethod(
      'copy',
      {'filePath': file.path, 'newPath': newPath},
    );
    return File(newPath);
  }

  @override
  Future<void> delete(IO.FileSystemEntity file, bool recursive) async {
    await _channel.invokeMethod(
      'delete',
      {'filePath': file.path, 'recursive': recursive},
    );
  }

  @override
  Future<bool> exists(IO.FileSystemEntity file) async {
    return await _channel.invokeMethod(
      'exists',
      {'filePath': file.path},
    );
  }

  @override
  Future<DateTime> lastAccessed(File file) async {
    final result = await _channel.invokeMethod(
      'lastAccessed',
      {'filePath': file.path},
    ) as int;
    return DateTime.fromMillisecondsSinceEpoch(result);
  }

  @override
  Future<DateTime> lastModified(File file) async {
    final result = await _channel.invokeMethod(
      'lastModified',
      {'filePath': file.path},
    ) as int;
    return DateTime.fromMillisecondsSinceEpoch(result);
  }

  @override
  Future<int> length(File file) async {
    final result = await _channel.invokeMethod(
      'length',
      {'filePath': file.path},
    ) as int;
    return result;
  }

  @override
  Future<List<String>> listDir(Directory file) async {
    final result = await _channel.invokeMethod(
      'listDir',
      {'filePath': file.path},
    );
    if (result is List) {
      return result.whereType<String>().toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> mkdir(Directory file, {bool recursive = false}) async {
    return await _channel.invokeMethod(
      'mkdir',
      {'filePath': file.path, 'recursive': recursive},
    );
  }

  @override
  Future<Uint8List> readFile(File file) async {
    final result = await _channel.invokeMethod(
      'readFile',
      {'filePath': file.path},
    );
    if (result is String) {
      return base64.decode(result);
    } else {
      throw "read file fail.";
    }
  }

  @override
  Future<void> rename(IO.FileSystemEntity file, String newPath) async {
    await _channel.invokeMethod(
      'rename',
      {'filePath': file.path, 'newPath': newPath},
    );
  }

  @override
  Future writeFile(File file, data, {bool isAppend = false}) async {
    await _channel.invokeMethod(
      'writeFile',
      {
        'filePath': file.path,
        'data': (() {
          if (data is String) {
            return data;
          } else if (data is Uint8List) {
            return base64.encode(data);
          } else {
            return "";
          }
        })(),
        'encoding': (() {
          if (data is String) {
            return 'utf8';
          } else if (data is Uint8List) {
            return 'base64';
          } else {
            return "utf8";
          }
        })(),
        'isAppend': isAppend,
      },
    );
  }
}
