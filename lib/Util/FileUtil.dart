// 管理文件


import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil{

  static String tag = "FileUtil";
  static FileUtil mInstance_ = FileUtil._internal();
  String base_dir = "";


  FileUtil._internal() {
  }


  factory FileUtil(){
    if(null == mInstance_){
      mInstance_ =  FileUtil._internal();
    }
    return mInstance_;
  }

  Future<String> GetBaseDir() async{
    if(base_dir.isEmpty){
      var dir = await getApplicationDocumentsDirectory();
      base_dir = dir.path;
    }
    print(tag+ " " + base_dir);
    return base_dir;
  }

  Future<String> GetDownloadDir() async{
    String download_dir = "/download/";
    return await GetBaseDir() + download_dir;
  }

  Future<String> GetUnzipDir() async{
    String unzip_dir = "/zip/";
    return await GetBaseDir() + unzip_dir;
  }


  /// 解压zip文件
  Future<void> unzip(String filename) async {
    var path = await GetDownloadDir()+filename;

    print(tag + "unzip " + path);

    var zip_file = File(path);
    Uint8List bytes = zip_file.readAsBytesSync();

    // 解压
    final archive = ZipDecoder().decodeBytes(bytes);

    // 设定要解压的目标文件夹
    var unzip_path = await GetUnzipDir();

    // 解压文件到磁盘
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$unzip_path/$filename')
          ..createSync(recursive: true) // 同步创建文件
          ..writeAsBytesSync(data); // 将解压出来的文件内容写入到文件
      } else {
        Directory('$unzip_path/$filename')
          ..create(recursive: true);
      }
    }
  }

}