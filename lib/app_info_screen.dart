import 'package:batterylevel/Util/DownLoadManage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_loading/m_loading.dart';
import 'Util/Server.dart';
import 'design_course_app_theme.dart';

class CourseInfoScreen extends StatefulWidget {
  app m_app;
  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
  CourseInfoScreen(this.m_app);
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  String str = "";
  // 0 uninstall ; 1 install ; 2 loading; ; 4 download err;
  int status = 0;
  Future _future;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
    setData();
    app m_app = widget.m_app;
  }
  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  Future<bool> downloadFile() async {
    String name = widget.m_app.name;
    if (name.indexOf('.zip') == -1) {
      name += ".zip";
    }
    print("start download " + name);
    return await DownLoadManage.getInstance().downloadFile(name);
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 1.2,
                    child: FadeInImage(
                      placeholder:
                          AssetImage('asset/design_course/interFace1.png'),
                      image: NetworkImage(widget.m_app.img),
                    )),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: DesignCourseAppTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DesignCourseAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              widget.m_app.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '     ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        widget.m_app.download_num.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // AnimatedOpacity(
                          //   duration: const Duration(milliseconds: 500),
                          //   opacity: opacity1,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8),
                          //     child: Row(
                          //       children: <Widget>[
                          //         getTimeBoxUI('24', 'Classe'),
                          //         getTimeBoxUI('2hours', 'Time'),
                          //         getTimeBoxUI('24', 'Seat'),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  'Lorem ipsum is simply dummy text of printing & typesetting industry, Lorem ipsum is simply dummy text of printing & typesetting industry.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          getBottomArea(),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: DesignCourseAppTheme.nearlyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: DesignCourseAppTheme.nearlyWhite,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: DesignCourseAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getBottomArea() {
    print(widget.m_app.is_install);
    print(status);
    if (status == 1) {
      str = "Downloaded! click again to delete!";
      Server.GetInstance().installApp(widget.m_app.name);
      return getInstallUI();
    }

    if (status == 2) {
      str = "loading " + widget.m_app.name;
      return getLoadingUI();
    }

    str = "click to download " + widget.m_app.name;
    if (status == 4) {
      str = "network err! Click to try again!";
    }

    return getUninstallUI();
  }

  Widget getUninstallUI() {
    print("getUninstallUI");
    //return getTimeBoxUI(str, ()=>{print("you click this")});
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: opacity3,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // status = 2;
                          // setState(() {});
                          print("you click this");
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            //color: DesignCourseAppTheme.nearlyBlue,
                            color: widget.m_app.is_install
                                ? DesignCourseAppTheme.grey
                                : DesignCourseAppTheme.nearlyBlue,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme.nearlyBlue
                                      .withOpacity(0.5),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              str,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                color: DesignCourseAppTheme.nearlyWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  void startApp() async {
    final channel = MethodChannel('com.jzhu.jump/plugin');

    await channel.invokeMethod('loadPlugin');
    await channel.invokeMethod('startPlugin');
  }

  void deleteApp() {}

  Widget getInstallUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Spacer(),
            getTimeBoxUI("启动", () => {startApp()}),
            Spacer(),
            getTimeBoxUI("卸载", () => {deleteApp()}),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: opacity3,
            child: Column(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              status = 2;
                              setState(() {});
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                //color: DesignCourseAppTheme.nearlyBlue,
                                color: widget.m_app.is_install
                                    ? DesignCourseAppTheme.grey
                                    : DesignCourseAppTheme.nearlyBlue,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: DesignCourseAppTheme.nearlyBlue
                                          .withOpacity(0.5),
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  str,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    color: DesignCourseAppTheme.nearlyWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            )),
      ],
    );
  }

  Widget getLoadingUI() {
    if (!widget.m_app.is_install) {
      print("init future");
      _future = downloadFile();
    }
    return FutureBuilder<bool>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              status = 4;
              widget.m_app.is_install = false;
              return getBottomArea();
            } else {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  status = 1;
                  widget.m_app.is_install = true;
                  return getBottomArea();
                }
              }
            }
            status = 4;
            widget.m_app.is_install = false;
            return getBottomArea();
          } else {
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

  void refresh() {
    setState(() {});
  }

  Widget getTimeBoxUI(String text1, Function callback) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: InkWell(
          onTap: () {
            print("you click this");
            callback();
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 28.0, right: 28.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
    Widget loading, {
    double width = 60,
    double height = 60,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                height: height,
                width: width,
                child: loading,
              ),
            ),
          );
        }));
      },
      child: Center(
        child: Container(
          height: height,
          width: width,
          child: loading,
        ),
      ),
    );
  }
}
