part of 'mp_file.dart';

class WXFileManager extends FileManager {
  @override
  Future<Directory> appBundleDirectory() {
    throw 'not support';
  }

  @override
  Future<Directory> appSandboxDirectory() async {
    final prefix = await mpjs.context['wx']['env']
        .getPropertyValue('USER_DATA_PATH') as String;
    return Directory('$prefix');
  }

  Future writeFile(File file, dynamic data, {bool isAppend = false}) async {
    final completer = Completer();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod(isAppend ? 'appendFile' : 'writeFile', [
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
        'success': (mpjs.JsObject res) {
          completer.complete();
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  Future<Uint8List> readFile(File file) async {
    final completer = Completer<Uint8List>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('readFile', [
      {
        'filePath': file.path,
        'encoding': 'base64',
        'success': (mpjs.JsObject res) async {
          completer.complete(base64.decode(await res.getPropertyValue('data')));
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<bool> exists(IO.FileSystemEntity file) async {
    final completer = Completer<bool>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('access', [
      {
        'path': file.path,
        'success': (mpjs.JsObject res) async {
          completer.complete(true);
        },
        'fail': (mpjs.JsObject res) async {
          completer.complete(false);
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<int> length(File file) async {
    final completer = Completer<int>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('getFileInfo', [
      {
        'filePath': file.path,
        'success': (mpjs.JsObject res) async {
          completer.complete(await res.getPropertyValue('size'));
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<File> copy(File file, String newPath) async {
    final completer = Completer<File>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('copyFile', [
      {
        'srcPath': file.path,
        'destPath': newPath,
        'success': (mpjs.JsObject res) async {
          completer.complete(File(newPath));
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<DateTime> lastAccessed(File file) async {
    final completer = Completer<DateTime>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('stat', [
      {
        'path': file.path,
        'success': (mpjs.JsObject res) async {
          completer.complete(DateTime.fromMillisecondsSinceEpoch(
              (await res['stats'].getPropertyValue('lastAccessedTime') as int) *
                  1000));
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<DateTime> lastModified(File file) async {
    final completer = Completer<DateTime>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('stat', [
      {
        'path': file.path,
        'success': (mpjs.JsObject res) async {
          completer.complete(DateTime.fromMillisecondsSinceEpoch(
              (await res['stats'].getPropertyValue('lastModifiedTime') as int) *
                  1000));
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<File> rename(IO.FileSystemEntity file, String newPath) async {
    final completer = Completer<File>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('access', [
      {
        'oldPath': file.path,
        'newPath': newPath,
        'success': (mpjs.JsObject res) async {
          completer.complete(File(newPath));
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<void> mkdir(Directory file, {bool recursive = false}) async {
    final completer = Completer<void>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('mkdir', [
      {
        'dirPath': file.path,
        'recursive': recursive,
        'success': (mpjs.JsObject res) async {
          completer.complete();
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }

  @override
  Future<List<String>> listDir(Directory file) async {
    final completer = Completer<List<String>>();
    final manager = await mpjs.context['wx'].callMethod('getFileSystemManager')
        as mpjs.JsObject;
    manager.callMethod('readdir', [
      {
        'dirPath': file.path,
        'success': (mpjs.JsObject res) async {
          completer.complete((await res.getPropertyValue('files') as List)
              .whereType<String>()
              .toList());
        },
        'fail': (mpjs.JsObject res) async {
          completer.completeError(await res.getPropertyValue('errMsg'));
        },
      }
    ]);
    return completer.future;
  }
}
