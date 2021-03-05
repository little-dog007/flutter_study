import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'card_data.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: CardFlipPage(),
    );
  }
}

// class StudyPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//          title:Text("study demo")
//         ),
//         body: Card(
//           color: Colors.red,
//
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               const ListTile(
//                 leading: Icon(Icons.album),
//                 title: Text('老孟'),
//                 subtitle: Text('一枚有态度的程序员'),
//               ),
//               ButtonBar(
//                 children: <Widget>[
//                   FlatButton(
//                     child: const Text('OK'),
//                     onPressed: () {
//
//                     },
//                   ),
//                   FlatButton(
//                     child: const Text('非常对'),
//                     onPressed: () {
//
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//         ,
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _batteryLevel = "";

  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const jumpAct = const MethodChannel('com.jzhu.jump/plugin');


  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result %';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<Null> _jumpToNative() async {
    String result = await jumpAct.invokeMethod('oneAct');
  }

  Future<Null> _jumpToPlugin() async {
    String result = await jumpAct.invokeMethod('startPlugin');
  }

  Future<Null> _loadPlugin() async {
    String result = await jumpAct.invokeMethod('loadPlugin');
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('jump to plugin'),
              onPressed: _jumpToPlugin,
            ),
            ElevatedButton(
              child: Text('load plugin'),
              onPressed: _loadPlugin,
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}


// 分隔

class CardFlipPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardFlipPageState();
}

class _CardFlipPageState extends State<CardFlipPage> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.blue,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 350,
                height: 300,
                padding: EdgeInsets.all(20),
                child: CardFlipper(
                    cards: cardDataList,
                    onScroll: (double sp) {
                      setState(() {
                        this.scrollPercent = sp;
                      });
                    }
                ) ,
              ),
            ],
          )
      ),
    );
  }
}

class CardFlipper extends StatefulWidget {
  CardFlipper({this.cards, this.onScroll});
  final List<CardData> cards;
  final Function(double scrollPercent) onScroll;
  @override
  State<StatefulWidget> createState() => _CardFlipper();
}

enum Direction {
  LEFT, RIGHT
}

class _CardFlipper extends State<CardFlipper> with TickerProviderStateMixin{
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;
  Direction direction = Direction.LEFT;

  @override
  void initState() {
    super.initState();
    finishScrollController = AnimationController(duration: Duration(milliseconds: 150), vsync: this)
      ..addListener((){
        setState((){
          scrollPercent = ui.lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);
          widget.onScroll(scrollPercent);
        });
      });
  }

  @override
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final allCardDragDistance = dragDistance / context.size.width;
    final numCards = widget.cards.length;
    if (allCardDragDistance > 0) {
      direction = Direction.LEFT;
    } else {
      direction = Direction.RIGHT;
    }
    setState(() {
      scrollPercent = (startDragPercentScroll + (- allCardDragDistance / numCards)).clamp(0.0, 1.0 - (1 / numCards));
      widget.onScroll(scrollPercent);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final numCards = widget.cards.length;
    finishScrollStart = scrollPercent;
    if (direction == Direction.LEFT) {
      finishScrollEnd = (scrollPercent * numCards).floor() / numCards;
    } else {
      finishScrollEnd = (scrollPercent * numCards).ceil() / numCards;
    }

    finishScrollController.forward(from: 0.0);
    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    int i = -1;
    return widget.cards.map<Widget>((cardData) {
      i++;
      return _buildCard(cardData, i, widget.cards.length, scrollPercent);
    }).toList();
  }

  Widget _buildCard(CardData cardData, int cardIndex, int cardCount, double scrollPercent) {
    final cardScrollPercent = scrollPercent * cardCount;
    final parallax = scrollPercent - (cardIndex / cardCount);

    return FractionalTranslation(
        translation: Offset(cardIndex - cardScrollPercent, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
              data: cardData,
              parallaxPercent: parallax
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }

}

class Card extends StatefulWidget {
  Card({@required this.data, this.parallaxPercent = 0.0});
  final CardData data;
  final double parallaxPercent;

  @override
  State<StatefulWidget> createState() => _CardState();
}

class _CardState extends State<Card> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRect(
          child: FractionalTranslation(
            translation: Offset(widget.parallaxPercent * 2.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.asset(
                widget.data.asset,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

      ],
    );
  }
}

class BottomBar extends StatefulWidget {
  BottomBar({this.cardCount, this.scrollPercent});
  final int cardCount;
  final double scrollPercent;

  @override
  State<StatefulWidget> createState() => _BottomBarState();

}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(child: Container(
            width: double.infinity,
            height: 5.0,
            child: ScrollIndicator(
                cardCount: widget.cardCount,
                scrollPercent: widget.scrollPercent
            ),
          )),
          Expanded(
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  ScrollIndicator({this.cardCount, this.scrollPercent});
  final int cardCount;
  final double scrollPercent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
          cardCount: cardCount,
          scrollPercent: scrollPercent
      ),
      child: Container(),
    );
  }

}

class ScrollIndicatorPainter extends CustomPainter {
  ScrollIndicatorPainter({
    this.cardCount, this.scrollPercent
  }) : trackPaint = Paint()
    ..color = Color(0xFF444444)
    ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
      ),
      trackPaint,
    );

    final thumbWidth = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(thumbLeft, 0.0, thumbWidth, size.height),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
      ),
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

