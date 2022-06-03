part of 'mp_file.dart';

class File extends IO.FileSystemEntity implements IO.File {
  String _path;

  File(this._path);

  @override
  IO.File get absolute => new File(_absolutePath);

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
  Future<IO.File> copy(String newPath) {
    return FileManager.getFileManager().copy(this, newPath);
  }

  @override
  Future<IO.File> create({bool recursive = false}) async {
    if (await exists()) {
      throw 'file exists';
    }
    if (recursive) {
      await parent.create(recursive: true);
    }
    await writeAsString('');
    return this;
  }

  @override
  Future<bool> exists() {
    return FileManager.getFileManager().exists(this);
  }

  @override
  Future<DateTime> lastAccessed() {
    return FileManager.getFileManager().lastAccessed(this);
  }

  @override
  Future<DateTime> lastModified() {
    return FileManager.getFileManager().lastModified(this);
  }

  @override
  Future<int> length() {
    return FileManager.getFileManager().length(this);
  }

  @override
  String get path => _path;

  @override
  Future<Uint8List> readAsBytes() {
    return FileManager.getFileManager().readFile(this);
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) {
    return readAsString(encoding: encoding).then(const LineSplitter().convert);
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) async {
    return encoding.decode(await readAsBytes());
  }

  @override
  Future<IO.File> rename(String newPath) async {
    await FileManager.getFileManager().rename(this, newPath);
    return File(newPath);
  }

  @override
  Future<IO.File> writeAsBytes(List<int> bytes,
      {IO.FileMode mode = IO.FileMode.write, bool flush = false}) async {
    await FileManager.getFileManager().writeFile(
      this,
      Uint8List.fromList(bytes),
      isAppend: mode == IO.FileMode.append,
    );
    return this;
  }

  @override
  Future<IO.File> writeAsString(String contents,
      {IO.FileMode mode = IO.FileMode.write,
      Encoding encoding = utf8,
      bool flush = false}) {
    return writeAsBytes(encoding.encode(contents), mode: mode, flush: flush);
  }

  // Not support methods.
  @override
  Uint8List readAsBytesSync() {
    throw 'not support sync operations.';
  }

  @override
  void setLastModifiedSync(DateTime time) {
    throw 'not support sync operations.';
  }

  @override
  void setLastAccessedSync(DateTime time) {
    throw 'not support sync operations.';
  }

  @override
  int lengthSync() {
    throw 'not support sync operations.';
  }

  @override
  void writeAsBytesSync(List<int> bytes,
      {IO.FileMode mode = IO.FileMode.write, bool flush = false}) {
    throw 'not support sync operations.';
  }

  @override
  IO.File copySync(String newPath) {
    throw 'not support sync operations.';
  }

  @override
  void createSync({bool recursive = false}) {
    throw 'not support sync operations.';
  }

  @override
  void writeAsStringSync(String contents,
      {IO.FileMode mode = IO.FileMode.write,
      Encoding encoding = utf8,
      bool flush = false}) {
    throw 'not support sync operations.';
  }

  @override
  bool existsSync() {
    throw 'not support sync operations.';
  }

  @override
  DateTime lastAccessedSync() {
    throw 'not support sync operations.';
  }

  @override
  DateTime lastModifiedSync() {
    throw 'not support sync operations.';
  }

  @override
  IO.RandomAccessFile openSync({IO.FileMode mode = IO.FileMode.read}) {
    throw 'not support sync operations.';
  }

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) {
    throw 'not support sync operations.';
  }

  @override
  String readAsStringSync({Encoding encoding = utf8}) {
    throw 'not support sync operations.';
  }

  @override
  IO.File renameSync(String newPath) {
    throw 'not support sync operations.';
  }

  @override
  Future<IO.RandomAccessFile> open({IO.FileMode mode = IO.FileMode.read}) {
    throw 'not support sync operations.';
  }

  @override
  Stream<List<int>> openRead([int? start, int? end]) {
    throw 'not support sync operations.';
  }

  @override
  IO.IOSink openWrite(
      {IO.FileMode mode = IO.FileMode.write, Encoding encoding = utf8}) {
    throw 'not support sync operations.';
  }

  @override
  Future setLastAccessed(DateTime time) {
    throw 'not support this operations.';
  }

  @override
  Future setLastModified(DateTime time) {
    throw 'not support this operations.';
  }
}
