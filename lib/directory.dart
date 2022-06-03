part of 'mp_file.dart';

class Directory extends IO.FileSystemEntity implements IO.Directory {
  static Directory current = Directory("/");

  String _path;

  Directory(this._path);

  @override
  IO.Directory get absolute => new Directory(_absolutePath);

  String get _absolutePath {
    if (isAbsolute) return path;
    String current = Directory.current.path;
    if (current.endsWith('/')) {
      return '$current$path';
    } else {
      return '$current/$path';
    }
  }

  @override
  Future<IO.Directory> create({bool recursive = false}) async {
    await FileManager.getFileManager().mkdir(this);
    return this;
  }

  @override
  Future<bool> exists() {
    return FileManager.getFileManager().exists(this);
  }

  @override
  Stream<IO.FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {
    throw 'use listDir';
  }

  Future<List<String>> listDir(
      {bool recursive = false, bool followLinks = true}) {
    return FileManager.getFileManager().listDir(this);
  }

  @override
  String get path => _path;

  @override
  Future<IO.Directory> rename(String newPath) async {
    await FileManager.getFileManager().rename(this, newPath);
    return Directory(newPath);
  }

  // not support methods.

  @override
  Future<IO.Directory> createTemp([String? prefix]) {
    throw 'not support sync operations.';
  }

  @override
  void createSync({bool recursive = false}) {
    throw 'not support sync operations.';
  }

  @override
  IO.Directory createTempSync([String? prefix]) {
    throw 'not support sync operations.';
  }

  @override
  bool existsSync() {
    throw 'not support sync operations.';
  }

  @override
  List<IO.FileSystemEntity> listSync(
      {bool recursive = false, bool followLinks = true}) {
    throw 'not support sync operations.';
  }

  @override
  IO.Directory renameSync(String newPath) {
    throw 'not support sync operations.';
  }
}
