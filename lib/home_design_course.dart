import 'package:batterylevel/popular_course_list_view.dart';
import 'package:flutter/material.dart';
import 'package:m_loading/m_loading.dart';
import 'Util/Server.dart';
import 'all_app_screen.dart';
import 'category_list_view.dart';
import 'app_info_screen.dart';
import 'design_course_app_theme.dart';
import 'models/Util.dart';

// 入口
class DesignHomeScreen extends StatefulWidget {
  @override
  _DesignHomeScreenState createState() => _DesignHomeScreenState();
}

class _DesignHomeScreenState extends State<DesignHomeScreen> {
  CategoryType categoryType = CategoryType.uninstall;
  Server server;
  Future _future;

  @override
  void initState() {
    server = Server.GetInstance();
    _future = Future.delayed(Duration(seconds: 0), () {
      server.init();
    });

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          print("build future");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return InkWell(
                onTap: () {
                    print("you click this");
                     _future = Future.delayed(Duration(seconds: 3), () {
                       server.init_test();
                    });
                    refersh();
                },
                child: Text("网络错误，点击重试",
                    style: TextStyle(
                      color: DesignCourseAppTheme.darkerText,
                    )),
              );
            }
            return getHomeUI();
          } else {
            print("get loading");
            return getloading(PacmanLoading(
              mouthColor: Colors.blue,
              ballColor: Colors.red,
            ));
          }
        });
  }

  Widget getloading(
    Widget loading, {
    double width = 60,
    double height = 60,
  }) {
    return Center(
      child: Container(
        height: height,
        width: width,
        child: loading,
      ),
    );
  }




  Widget getHomeUI() {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                print("you click 刷新");
                _future = Future.delayed(Duration(seconds: 3), () {
                  server.init();
                });
                refersh();
              },
              child: Text("刷新"),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            // expanded 是 Flexible 控件的fix 设置为FlexFit.tight,强制填充剩余空间
            Expanded(
              // SingleChildScrollView 区域可以滚动
              child: SingleChildScrollView(
                child: getSingleChildScroll(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            '分类',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(CategoryType.uninstall,
                  categoryType == CategoryType.uninstall),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(CategoryType.installed,
                  categoryType == CategoryType.installed),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // CategoryListView(
        //   callBack: () {
        //     moveTo();
        //   },
        // ),
      ],
    );
  }

  Widget getSingleChildScroll() {
    return Container(
      // MediaQuery.of(context) 获取设备信息
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          // getSearchBarUI(),
          getCategoryUI(),

          Flexible(
            child: getCardArea(),
          ),
        ],
      ),
    );
  }

  Widget getPopularCourseUI(bool install) {
    String txt = '';
    List<app> lst = [];
    if (server.apps_lst != null) {
      lst = List.from(server.apps_lst);
      print(lst);
      if (install) {
        txt = "已安装的小插件";

        lst = server.apps_lst
            .where((element) => element.is_install == true)
            .toList();
      } else {
        txt = "热门插件";

        lst = server.apps_lst
            .where((element) => element.is_install != true)
            .toList();
        lst.sort(
            (left, right) => right.download_num.compareTo(left.download_num));
      }
    } else {
      print("getPopularCourseUI :" + "server.apps_lst == null");
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  )),
              Spacer(),
              InkWell(
                onTap: () {
                  print("click");
                  moveToSeeAll(categoryType == CategoryType.installed);
                },
                child: Text("see all",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: DesignCourseAppTheme.nearlyBlue,
                        letterSpacing: 0.27)),
              )
            ],
          ),
          Flexible(
            child: PopularCourseListView(
                callBack: (app m_app) {
                  moveTo(m_app);
                },
                apps_card_lst: lst),
          )
        ],
      ),
    );
  }

  void moveTo(app m_app) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseInfoScreen(m_app),
      ),
    ).then((value) => value ? refersh() : print("not refersh"));
  }

  void refersh() {
    setState(() {});
  }

  void moveToSeeAll(bool is_install) {
    List<app> lst = [];
    if (server.apps_lst != null) {
      lst = List.from(server.apps_lst);
    } else {
      print("getPopularCourseUI :" + "server.apps_lst == null");
    }

    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) =>
            AllappScreen((app m_app) => {moveTo(m_app)}, lst, is_install),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    bool install = false;
    if (CategoryType.uninstall == categoryTypeData) {
      txt = '未安装';
    } else if (CategoryType.installed == categoryTypeData) {
      txt = '已安装';
      install = true;
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: '搜索小工具',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    // 固定宽高的组件
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  // 头部提示
  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '选择你',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  '喜欢的小工具',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Image.asset('asset/design_course/userImage.png'),
          )
        ],
      ),
    );
  }

  Widget getCardArea() {
    return Column(
      children: [
        Flexible(
          child: getPopularCourseUI(categoryType == CategoryType.installed),
        ),
      ],
    );
  }
}

enum CategoryType {
  uninstall,
  installed,
}
