part of 'mp_file.dart';

abstract class FileManager {
  static FileManager getFileManager() {
    if (MPEnv.envHost() == MPEnvHostType.wechatMiniProgram) {
      return WXFileManager();
    } else if (MPEnv.envHost() == MPEnvHostType.playboxProgram) {
      return PBFileManager();
    } else if (MPEnv.debugEnvHost != null) {
      return IOFileManager();
    }
    throw 'No available file manager.';
  }

  Future<Directory> appBundleDirectory();
  Future<Directory> appSandboxDirectory();
  Future writeFile(File file, dynamic data, {bool isAppend = false});
  Future<Uint8List> readFile(File file);
  Future<bool> exists(IO.FileSystemEntity file);
  Future<File> copy(File file, String newPath);
  Future<void> rename(IO.FileSystemEntity file, String newPath);
  Future<void> delete(IO.FileSystemEntity file, bool recursive);
  Future<DateTime> lastAccessed(File file);
  Future<DateTime> lastModified(File file);
  Future<int> length(File file);
  Future<void> mkdir(Directory file, {bool recursive = false});
  Future<List<String>> listDir(Directory file);
}
