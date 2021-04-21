

import 'package:batterylevel/popular_course_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Util/Server.dart';
import 'app_info_screen.dart';
import 'design_course_app_theme.dart';

class AllappScreen extends StatefulWidget {
  final Function call_back;
   List<app> app_lst;
  final bool is_install;

  @override
  _AllappScreen createState() => _AllappScreen();
   AllappScreen(this.call_back, this.app_lst,this.is_install);
}

class _AllappScreen extends State<AllappScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: DesignCourseAppTheme.nearlyWhite,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .padding
                        .top),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppBar().preferredSize.height,
                          height: AppBar().preferredSize.height,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                              BorderRadius.circular(
                                  AppBar().preferredSize.height),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: DesignCourseAppTheme.nearlyBlack,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(widget.is_install ? "已安装" : "未安装",
                          style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 0.5
                          ),
                        ),
                        Spacer()
                      ],
                    )

                ),
                Flexible(
                  child: PopularCourseListView(
                    callBack: (app m_app) {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              CourseInfoScreen(m_app),
                        ),
                      ).then((value) =>
                      value ? refersh() : print("not refersh"));
                    },
                    apps_card_lst: widget.app_lst,
                  ),
                ),

              ],
            )));
  }

  void refersh() {
    widget.app_lst = widget.app_lst.where((element) => element.is_install == widget.is_install).toList();
    setState(() {

    });
  }
}


