part of 'mp_file.dart';

class WebFileManager extends FileManager {
  static IO.Directory? sandboxDirectory;

  @override
  Future<Directory> appBundleDirectory() {
    throw 'not support';
  }

  @override
  Future<Directory> appSandboxDirectory() async {
    throw 'not support';
  }

  @override
  Future<File> copy(File file, String newPath) async {
    throw 'not support';
  }

  @override
  Future<bool> exists(IO.FileSystemEntity file) {
    throw 'not support';
  }

  @override
  Future<DateTime> lastAccessed(File file) {
    throw 'not support';
  }

  @override
  Future<DateTime> lastModified(File file) {
    throw 'not support';
  }

  @override
  Future<int> length(File file) {
    throw 'not support';
  }

  @override
  Future<List<String>> listDir(Directory file) async {
    throw 'not support';
  }

  @override
  Future<void> mkdir(Directory file, {bool recursive = false}) {
    throw 'not support';
  }

  @override
  Future<Uint8List> readFile(File file) async {
    if (file._jsObject != null) {
      final completer = Completer<Uint8List>();
      try {
        final fileReader = await mpjs.context.newObject("FileReader");
        fileReader.callMethod("addEventListener", [
          "load",
          (mpjs.JsObject res) async {
            final result =
                await fileReader.getPropertyValue("result") as String;
            completer.complete(base64.decode(result.split('base64,')[1]));
          }
        ]);
        fileReader.callMethod("readAsDataURL", [file._jsObject]);
      } catch (e) {
        completer.completeError(e);
      }
      return completer.future;
    }
    throw 'File Object not exists.';
  }

  @override
  Future<void> rename(IO.FileSystemEntity file, String newPath) {
    throw 'not support';
  }

  @override
  Future writeFile(File file, data, {bool isAppend = false}) {
    throw 'not support';
  }

  @override
  Future<void> delete(IO.FileSystemEntity file, bool recursive) async {
    throw 'not support';
  }
}
