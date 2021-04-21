import 'dart:convert';
import 'package:batterylevel/Util/FileUtil.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';

// 网络下载管理器 单例
class DownLoadManage {
  static String tag = "DownLoadManage";
  static DownLoadManage mInstance_;
  Dio dio = null;

  DownLoadManage._internal() {
    dio = Dio();
  }

  static DownLoadManage _getIntances() {
    if (mInstance_ == null) {
      mInstance_ = DownLoadManage._internal();
    }
    return mInstance_;
  }

  factory DownLoadManage.getInstance() => _getIntances();


  String URLGetter(String file_name){
    String base_url = "http://10.255.45.180";
    String prot = "8000";
    return base_url+":"+prot+"/" + file_name;
  }

  Future<bool> downloadFile(String file_name) async {
    String save_dir = await FileUtil().GetDownloadDir();
    String save_path = save_dir + file_name;

    String download_url = URLGetter(file_name) ;

    try {
      //2、创建文件
      FileUtils.mkdir([save_dir]);

      print("start download:"+ download_url );
      print("save in " + save_path);

      await dio.download(
        download_url,
        save_path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print(tag + "receivedBytes " + receivedBytes.toString());
          print(tag + "totalBytes " + totalBytes.toString());
        },
      );
    } catch (e) {
      print(tag + "can not download");
      print(e);
      return false;
    }

    print("download complete");
    return true;
  }

  // 计算文件md5

  static String GetMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}

