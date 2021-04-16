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
    String base_url = "http://10.90.185.207:8000/";
    return base_url;
  }

  Future<void> downloadFile(String file_name) async {
    String save_dir = await FileUtil().GetDownloadDir();
    String save_path = save_dir + file_name;

    String download_url = URLGetter(file_name) + file_name;

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
      return;
    }

    print("download complete");
  }

  // 计算文件md5

  static String GetMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}

// // http 网络请求单元
// class HttpUtil{
//    static final String url = "https://www.baidu.com";
//    static void OnRequest() async{
//      bool is_success = false;
//      try {
//        //创建一个HttpClient
//        HttpClient httpClient = new HttpClient();
//        //打开Http连接
//        HttpClientRequest request = await httpClient.getUrl(
//            Uri.parse(url));
//        //使用iPhone的UA
//        request.headers.add("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1");
//        //等待连接服务器（会将请求信息发送给服务器）
//        var response = await request.close();
//        Directory tempDir = await getTemporaryDirectory();
//        String tempPath = tempDir.path;
//        File file = new File('$tempPath/$userId.png');
//
//        await file.writeAsBytes(response.bodyBytes);
//        //读取响应内容
//        String _text = await response.transform(utf8.decoder).join();
//        //输出响应头
//        print(response.headers);
//
//        //关闭client后，通过该client发起的所有请求都会中止。
//        httpClient.close();
//        is_success = true;
//
//      } catch (e) {
//        is_success = false;
//      }
//    }
//
//    static void HandleResponse(HttpClientResponse response) async {
//      // doing something ,用于处理返回信息
//      var bytes = consolidateHttpClientResponseBytes(response);
//      Directory tempDir = await getTemporaryDirectory();
//      String tempPath = tempDir.path;
//      File file = new File('$tempPath/$userId.png');
//      await file.writeAsBytes(response.bodybytes);
//      displayImage(file);
//    }
// }
