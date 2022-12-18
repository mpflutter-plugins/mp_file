part of 'mp_file.dart';

enum FilePickerMediaType {
  unlimited,
  image,
  video,
}

enum FilePickerSourceType {
  unlimited,
  album,
  camera,
}

enum FilePickerCameraType {
  back,
  front,
}

class FilePicker {
  static Future<List<File>> chooseMedia({
    FilePickerMediaType? mediaType,
    FilePickerSourceType? sourceType,
    FilePickerCameraType? cameraType,
    int? count,
    Duration? maxDuration,
    bool? compressed,
  }) async {
    if (MPEnv.envHost() == MPEnvHostType.wechatMiniProgram) {
      final completer = Completer<List<File>>();
      mpjs.context['wx'].callMethod('chooseMedia', [
        {
          "count": count,
          "maxDuration": maxDuration,
          "sizeType": (() {
            if (compressed != null && compressed) {
              return ["compressed"];
            } else {
              return ["original"];
            }
          })(),
          "mediaType": (() {
            if (mediaType == null) return null;
            switch (mediaType) {
              case FilePickerMediaType.unlimited:
                return ['mix'];
              case FilePickerMediaType.image:
                return ['image'];
              case FilePickerMediaType.video:
                return ['video'];
              default:
                return ['mix'];
            }
          })(),
          "sourceType": (() {
            if (sourceType == null) return null;
            switch (sourceType) {
              case FilePickerSourceType.unlimited:
                return null;
              case FilePickerSourceType.album:
                return ['album'];
              case FilePickerSourceType.camera:
                return ['camera'];
              default:
                return null;
            }
          })(),
          "cameraType": (() {
            if (cameraType == null) return null;
            switch (cameraType) {
              case FilePickerCameraType.front:
                return ['front'];
              case FilePickerCameraType.back:
                return ['back'];
              default:
                return null;
            }
          })(),
          'success': (mpjs.JsObject res) async {
            try {
              final encodedData =
                  await mpjs.context["JSON"].callMethod("stringify", [res]);
              final data = json.decode(encodedData);
              if (data is Map && data["tempFiles"] is List) {
                final tempFiles = data["tempFiles"] as List;
                completer.complete(
                    tempFiles.map((e) => File(e["tempFilePath"])).toList());
                return;
              }
              completer.completeError(data["errMsg"]);
            } catch (e) {
              completer.completeError(e);
            }
          },
          'fail': (mpjs.JsObject res) async {
            completer.completeError("fail");
          },
        }..removeWhere((key, value) => value == null)
      ]);
      final result = await completer.future;
      return result;
    } else if (MPEnv.envHost() == MPEnvHostType.browser) {
      final completer = Completer<List<File>>();
      final isIPhoneSafari = ((await mpjs.context["navigator"]
              .getPropertyValue("appVersion")) as String)
          .contains("iPhone OS");
      if (isIPhoneSafari) {
        throw 'iPhone WebView 不支持使用 FilePicker 选取文件，请使用 FilePickerView。';
      } else {
        final inputElement = await mpjs.context["document"]
            .callMethod("createElement", ["input"]) as mpjs.JsObject;
        await inputElement.callMethod("setAttribute", ["type", "file"]);
        if (count != null && count > 1) {
          await inputElement
              .callMethod("setAttribute", ["multiple", "multiple"]);
        }
        if (mediaType == FilePickerMediaType.image) {
          await inputElement.callMethod("setAttribute", ["accept", "image/*"]);
        } else if (mediaType == FilePickerMediaType.video) {
          await inputElement.callMethod("setAttribute", ["accept", "video/*"]);
        } else {
          await inputElement.callMethod("setAttribute", ["accept", "*"]);
        }
        if (sourceType == FilePickerSourceType.camera) {
          await inputElement.callMethod("setAttribute", ["capture", "camera"]);
          if (cameraType == FilePickerCameraType.front) {
            await inputElement.callMethod("setAttribute", ["capture", "user"]);
          }
        }
        inputElement.callMethod(
          "addEventListener",
          [
            "change",
            (mpjs.JsObject event) async {
              final files = <File>[];
              final jsFiles =
                  await inputElement.getPropertyValue("files") as mpjs.JsObject;
              final isFilesLength =
                  await jsFiles.getPropertyValue("length") as int;
              for (var i = 0; i < isFilesLength; i++) {
                files.add(File("", await jsFiles.getPropertyValue(i)));
              }
              completer.complete(files);
            },
          ],
        );
        inputElement.callMethod("click");
      }

      return completer.future;
    }
    return [];
  }
}

class FilePickerView extends StatelessWidget {
  final Function(List<File>) onPickFile;
  final ValueKey<String> fileKey;

  FilePickerView({
    required this.fileKey,
    required this.onPickFile,
    FilePickerMediaType? mediaType,
    FilePickerSourceType? sourceType,
    FilePickerCameraType? cameraType,
    int? count,
  }) {
    Future.delayed(Duration(milliseconds: 100)).then((value) async {
      final inputElement = await mpjs.context["document"]
          .callMethod("getElementById", [this.fileKey.value]) as mpjs.JsObject;
      await inputElement.callMethod("setAttribute", ["type", "file"]);
      if (count != null && count > 1) {
        await inputElement.callMethod("setAttribute", ["multiple", "multiple"]);
      }
      if (mediaType == FilePickerMediaType.image) {
        await inputElement.callMethod("setAttribute", ["accept", "image/*"]);
      } else if (mediaType == FilePickerMediaType.video) {
        await inputElement.callMethod("setAttribute", ["accept", "video/*"]);
      } else {
        await inputElement.callMethod("setAttribute", ["accept", "*"]);
      }
      if (sourceType == FilePickerSourceType.camera) {
        await inputElement.callMethod("setAttribute", ["capture", "camera"]);
        if (cameraType == FilePickerCameraType.front) {
          await inputElement.callMethod("setAttribute", ["capture", "user"]);
        }
      }
      await inputElement.callMethod(
        "addEventListener",
        [
          "change",
          (mpjs.JsObject event) async {
            final files = <File>[];
            final jsFiles =
                await inputElement.getPropertyValue("files") as mpjs.JsObject;
            final isFilesLength =
                await jsFiles.getPropertyValue("length") as int;
            for (var i = 0; i < isFilesLength; i++) {
              files.add(File("", await jsFiles.getPropertyValue(i)));
            }
            onPickFile(files);
          },
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MPPlatformView(
      viewType: 'mp_platform_view',
      viewAttributes: {
        'tag': 'input',
        'id': fileKey.value,
        'type': 'file',
        'style': 'opacity: 0.0;width:100%;height:100%',
      },
    );
  }
}
