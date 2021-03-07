import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'card_data.dart';

class TipicalView extends StatefulWidget {
  @override
  _TipicalViewState createState() => _TipicalViewState();
}

class _TipicalViewState extends State<TipicalView> {
  List<CardData> cardDataList_;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardDataList_ = cardDataList;
    print("length"+cardDataList_.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 500,
      child:Column(
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
      ) ,
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
            onPressed: () {},
            child: Text('时钟'),
          ),
        )
      ],
    );
  }

  List<Widget> _build_widgets() {
    List<Widget> widget_list= [];
    for (int i = 0; i < this.cardDataList_.length; ++i) {
      print("${cardDataList_[i].id}");

      widget_list.add(_singal_widget(cardDataList_[i]));
    }
    return widget_list;
  }

}
