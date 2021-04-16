import 'package:batterylevel/Util/FileUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DownLoadManage.dart';
import 'card_data.dart';


class TipicalView extends StatefulWidget {
  @override
  _TipicalViewState createState() => _TipicalViewState();
}

const jumpAct = const MethodChannel('com.jzhu.jump/plugin');

Future<Null> load() async {
  await jumpAct.invokeMethod('loadPlugin');
}

Future<Null> jump() async {
  await jumpAct.invokeMethod('startPlugin');
}


class _TipicalViewState extends State<TipicalView> {
  List<CardData> cardDataList_;
  DownLoadManage downLoadManage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardDataList_ = cardDataList;
    downLoadManage = DownLoadManage.getInstance();
    print("length" + cardDataList_.length.toString());
  }

  Future<void> click() async {
    await downLoadManage.downloadFile("plugin_module-debug.zip");
  }

  Future<void> unzip() {
    FileUtil().unzip("plugin_module-debug.zip");
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 500,
      child: Column(
        children: [
          Text(
            'topical application',
            style: TextStyle(
                fontSize: 50
            ),

          ),
          Container(
            child: Row(children: _build_widgets()),
          )
        ],
      ),
    );
  }

  Widget _singal_widget(CardData card_data) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(card_data.asset),
                )),
            child: TextButton(
              onPressed: load,
              child: Text('load'),
            )
        ),
        Container(
          child: TextButton(
            onPressed:jump,
            child: Text("jump"),
          ),
        )

      ],
    );
  }

  List<Widget> _build_widgets() {
    List<Widget> widget_list = [];
    for (int i = 0; i < this.cardDataList_.length; ++i) {
      print("${cardDataList_[i].id}");

      widget_list.add(_singal_widget(cardDataList_[i]));
    }
    return widget_list;
  }

}
