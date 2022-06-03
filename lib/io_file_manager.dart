part of 'mp_file.dart';

class IOFileManager extends FileManager {
  static IO.Directory? sandboxDirectory;

  @override
  Future<Directory> appBundleDirectory() {
    throw 'not support';
  }

  @override
  Future<Directory> appSandboxDirectory() async {
    sandboxDirectory ??= await IO.Directory(IO.Directory.systemTemp.path)
        .createTemp("com.mpflutter.mpfile");
    return Directory(sandboxDirectory!.path);
  }

  @override
  Future<File> copy(File file, String newPath) async {
    await IO.File(file.path).copy(newPath);
    return File(newPath);
  }

  @override
  Future<bool> exists(IO.FileSystemEntity file) {
    return IO.File(file.path).exists();
  }

  @override
  Future<DateTime> lastAccessed(File file) {
    return IO.File(file.path).lastAccessed();
  }

  @override
  Future<DateTime> lastModified(File file) {
    return IO.File(file.path).lastModified();
  }

  @override
  Future<int> length(File file) {
    return IO.File(file.path).length();
  }

  @override
  Future<List<String>> listDir(Directory file) async {
    return IO.Directory(file.path).listSync().map((e) => e.path).toList();
  }

  @override
  Future<void> mkdir(Directory file, {bool recursive = false}) {
    return IO.Directory(file.path).create(recursive: recursive);
  }

  @override
  Future<Uint8List> readFile(File file) {
    return IO.File(file.path).readAsBytes();
  }

  @override
  Future<void> rename(IO.FileSystemEntity file, String newPath) {
    return IO.File(file.path).rename(newPath);
  }

  @override
  Future writeFile(File file, data, {bool isAppend = false}) {
    return IO.File(file.path).writeAsBytes((() {
      if (data is String) {
        return utf8.encode(data);
      } else if (data is Uint8List) {
        return data;
      } else {
        return Uint8List(0);
      }
    })(), mode: isAppend ? IO.FileMode.append : IO.FileMode.write);
  }
}
