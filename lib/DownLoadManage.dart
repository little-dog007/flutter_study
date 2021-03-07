
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:io';


// 网络下载管理器 单例
class DownLoadManage{
   static DownLoadManage mInstance_;

   DownLoadManage._internal(){}

   static DownLoadManage GetIntances(){
     if(mInstance_ == null){
       mInstance_ = DownLoadManage._internal();
     }
     return mInstance_;
   }


}

// 计算文件md5
class MD5Util {
  static String GetMd5(String data){
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}

// http 网络请求单元
class HttpUtil{
   static final String url = "https://www.baidu.com";
   static void OnRequest() async{
     bool is_success = false;
     try {
       //创建一个HttpClient
       HttpClient httpClient = new HttpClient();
       //打开Http连接
       HttpClientRequest request = await httpClient.getUrl(
           Uri.parse(url));
       //使用iPhone的UA
       request.headers.add("user-agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1");
       //等待连接服务器（会将请求信息发送给服务器）
       HttpClientResponse response = await request.close();
       //读取响应内容
       String _text = await response.transform(utf8.decoder).join();
       //输出响应头
       print(response.headers);

       //关闭client后，通过该client发起的所有请求都会中止。
       httpClient.close();
       is_success = true;

     } catch (e) {
       is_success = false;
     }
   }

   static void HandleResponse(HttpClientResponse response){
     // doing something ,用于处理返回信息
   }
}