import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _instance = FileManager._internal();

  factory FileManager() {
    return _instance;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    debugPrint(path);
    return File('$path/mock/data.txt');
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  FileManager._internal() {
    //init logic
  }
}
