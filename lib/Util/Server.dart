import 'dart:convert';
import 'dart:io';

import 'package:batterylevel/Util/DownLoadManage.dart';
import 'package:batterylevel/Util/FileUtil.dart';

class default_config{
   String DEFAULT_DIR = ""; // 默认服务器存放apk路径
   String DEFAULT_IMG = ""; // 如果未找到app图片，默认展示的图片
}

class app{
  String id = ""; // 标识符
  String name = ""; // 插件名称
  String img = ""; // 插件图片 路径
  int download_num = 0; // 插件总下载数
  bool is_install = false;
  app.formapp(this.id,this.name,this.img,this.download_num,this.is_install);
  app();
}


class Server{
  static String tag = "server :";
  default_config config_ =  new default_config();
  List<app> apps_lst = [];

  static Server mInstance_;

  static Server GetInstance(){
    if(mInstance_ == null){
      mInstance_ = Server();
    }
    return mInstance_;
  }

  void init_test(){
    print("init test");
    apps_lst.clear();
    test();
  }
  void init() async{
    print("init");
    apps_lst.clear();
    DownLoadManage downLoadManage = DownLoadManage.getInstance();
    if(downLoadManage != null){
      String jsons_ext = "apps.json";
      bool ret = await downLoadManage.downloadFile('apps.json');
      print(ret);
      if(!ret){
        init_test();
        return;
      }
      String apps_file_path = (await FileUtil().GetDownloadDir() )+ jsons_ext;
      print(tag + apps_file_path);
      try{
        File file = new File(apps_file_path);
        String str = await file.readAsString();
        int pos = str.indexOf('{');
        str = str.substring(pos);
        final json_lst =  json.decode(str);
        init_config(json_lst);


      }catch(e){
        print("server init err");
        print(e);
      }

    }
  }

  void init_config(dynamic json_lst){
    CheckConfig();
    try {
      final map_ = new Map<String, dynamic>.from(json_lst);
      print(map_);
      apps_lst.clear();
      map_.forEach((key, value) {
        if(key == "default_config"){
          config_.DEFAULT_DIR = value["default_dir"];
          config_.DEFAULT_IMG = value["default_img"];
        }else{
          app app_ = new app();
          app_.id = key;
          if(value["name"] != null){
              app_.name = value["name"];
          }
          if(value["img"] != null){
            app_.img = DownLoadManage.getInstance().URLGetter(value["img"]);
          }
          if(value["download_num"] != null){
            app_.download_num = int.parse(value["download_num"]);
          }
          apps_lst.add(app_);
        }
      });
    }catch(e){
      print(tag + "init_config err");
      print(e);
    }
    CheckConfig();
  }

  void CheckConfig(){
    if(config_ == null){
      print("Server.config_ is null");
    }
    if(apps_lst == null){
      print("Server apps_lst  is null");
    }
    print("default config:");
    print(config_.DEFAULT_IMG);
    print(config_.DEFAULT_DIR);

    print("apps lst:");
    apps_lst.forEach((element) {
      print(element.id);
      print(element.name);
      print(element.img);
      print(element.download_num);
    });
  }

  void installApp(String name){
    apps_lst.forEach((element) {
      if(element.name == name){
        element.is_install = true;
      }
    });
  }

  void deleteApp(String name){
    apps_lst.forEach((element) {
      if(element.name == name){
        element.is_install = true;
      }
    });
  }
  void test(){
    apps_lst.add(new app.formapp("test1","test1_app","test1.img",20,false));
    apps_lst.add(new app.formapp("test2","test2_app","test1.img",2,false));
    apps_lst.add(new app.formapp("test3","test3_app","test1.img",200,false));
    apps_lst.add(new app.formapp("test4","test4_app","test1.img",210,false));
    apps_lst.add(new app.formapp("test5","test5_app","test1.img",200,false));
    apps_lst.add(new app.formapp("test6","test6_app","test1.img",20,false));
    apps_lst.add(new app.formapp("test7","test7_app","test1.img",20,false));
    apps_lst.add(new app.formapp("test8","test8_app","test1.img",20,false));
    apps_lst.add(new app.formapp("test9","test9_app","test1.img",20,false));
    apps_lst.add(new app.formapp("test10","test10_app","test1.img",20,true));
    apps_lst.add(new app.formapp("test11","test11_app","test1.img",20,true));

  }




}