
import 'package:batterylevel/Util/Server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Util/DownLoadManage.dart';

class AppsJsonTest extends StatelessWidget{
  Future<void> getJsonFile(){
    // DownLoadManage downLoadManage = DownLoadManage.getInstance();
    // downLoadManage.downloadFile("apps.json");
    Server sever = Server.GetInstance();
    sever.init();
  }

  Future<void> getImag() async {
    Server server = Server.GetInstance();
    await server.init();
    String str = "";
    server.apps_lst.forEach((element) {
      if(element.id == "plugin_module-debug.zip"){
        str = element.img;
      }
    });
    if(!str.isEmpty){
      DownLoadManage.getInstance().downloadFile(str);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          RaisedButton(
            child: Text('下载图片'),
            onPressed: (){
              getImag();
            },
          ),
          RaisedButton(
            child: Text('下载json'),
            onPressed: (){
              getJsonFile();
            },
          ),
          FadeInImage(
            placeholder:AssetImage('asset/design_course/interFace1.png'),
            image: NetworkImage("http://193.168.13.129:8000/tux.png"),
          )
        ],

    );
  }
}