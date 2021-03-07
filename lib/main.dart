import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'Topical_view.dart';
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
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("custom"),
        ),
        body: TipicalView(),
      ),
    );
  }
}

//
// class CardFlipPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CardFlipPageState();
// }
//
// class _CardFlipPageState extends State<CardFlipPage> {
//   double scrollPercent = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Colors.white,
//       ),
//       // scaffold 提供了页面的框架
//       home: Scaffold(
//           backgroundColor: Colors.white,
//           body: Column(
//             // 水平轴和交叉轴
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                   "Topical application",
//                 style: TextStyle(
//                   fontSize: 30,
//                 ),
//               ),
//               Container(
//                 width: 350,
//                 height: 200,
//                 // edgeInsets.all 所有方向使用相同数值的填充
//                 child: CardFlipper(
//                     cards: cardDataList,
//                     onScroll: (double sp) {
//                       setState(() {
//                         this.scrollPercent = sp;
//                       });
//                     }),
//               ),
//               Text(
//                 "all application",
//                 style: TextStyle(
//                   fontSize: 30,
//                 ),
//               ),
//               Container(
//                 width: 350,
//                 height: 200,
//                 // edgeInsets.all 所有方向使用相同数值的填充
//                 child: CardFlipper(
//                     cards: cardDataList,
//                     onScroll: (double sp) {
//                       setState(() {
//                         this.scrollPercent = sp;
//                       });
//                     }),
//               ),
//               Text(
//                 "my application",
//                 style: TextStyle(
//                   fontSize: 30,
//                 ),
//               ),
//               Container(
//                 width: 350,
//                 height: 200,
//                 // edgeInsets.all 所有方向使用相同数值的填充
//                 child: CardFlipper(
//                     cards: cardDataList,
//                     onScroll: (double sp) {
//                       setState(() {
//                         this.scrollPercent = sp;
//                       });
//                     }),
//               ),
//
//             ],
//           )),
//     );
//   }
// }
//
// class CardFlipper extends StatefulWidget {
//   CardFlipper({this.cards, this.onScroll});
//
//   final List<CardData> cards;
//   final Function(double scrollPercent) onScroll;
//
//   @override
//   State<StatefulWidget> createState() => _CardFlipper();
// }
//
// enum Direction { LEFT, RIGHT }
//
// class _CardFlipper extends State<CardFlipper> with TickerProviderStateMixin {
//   double scrollPercent = 0.0;
//   Offset startDrag;
//   double startDragPercentScroll;
//   double finishScrollStart;
//   double finishScrollEnd;
//   AnimationController finishScrollController;
//   Direction direction = Direction.LEFT;
//
//   @override
//   void initState() {
//     super.initState();
//     finishScrollController =
//         AnimationController(duration: Duration(milliseconds: 150), vsync: this)
//           ..addListener(() {
//             setState(() {
//               scrollPercent = ui.lerpDouble(finishScrollStart, finishScrollEnd,
//                   finishScrollController.value);
//               widget.onScroll(scrollPercent);
//             });
//           });
//   }
//
//   @override
//   void dispose() {
//     finishScrollController.dispose();
//     super.dispose();
//   }
//
//   void _onHorizontalDragStart(DragStartDetails details) {
//     startDrag = details.globalPosition;
//     startDragPercentScroll = scrollPercent;
//   }
//
//   void _onHorizontalDragUpdate(DragUpdateDetails details) {
//     final currDrag = details.globalPosition;
//     final dragDistance = currDrag.dx - startDrag.dx;
//     final allCardDragDistance = dragDistance / context.size.width;
//     final numCards = widget.cards.length;
//     if (allCardDragDistance > 0) {
//       direction = Direction.LEFT;
//     } else {
//       direction = Direction.RIGHT;
//     }
//     setState(() {
//       scrollPercent =
//           (startDragPercentScroll + (-allCardDragDistance / numCards))
//               .clamp(0.0, 1.0 - (1 / numCards));
//       widget.onScroll(scrollPercent);
//     });
//   }
//
//   void _onHorizontalDragEnd(DragEndDetails details) {
//     final numCards = widget.cards.length;
//     finishScrollStart = scrollPercent;
//     if (direction == Direction.LEFT) {
//       finishScrollEnd = (scrollPercent * numCards).floor() / numCards;
//     } else {
//       finishScrollEnd = (scrollPercent * numCards).ceil() / numCards;
//     }
//
//     finishScrollController.forward(from: 0.0);
//     setState(() {
//       startDrag = null;
//       startDragPercentScroll = null;
//     });
//   }
//
//   List<Widget> _buildCards() {
//     int i = -1;
//     return widget.cards.map<Widget>((cardData) {
//       i++;
//       return _buildCard(cardData, i, widget.cards.length, scrollPercent);
//     }).toList();
//   }
//
//   Widget _buildCard(
//       CardData cardData, int cardIndex, int cardCount, double scrollPercent) {
//     final cardScrollPercent = scrollPercent * cardCount;
//     final parallax = scrollPercent - (cardIndex / cardCount);
//
//     return FractionalTranslation(
//         translation: Offset(cardIndex - cardScrollPercent, 0.0),
//         child: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Card(data: cardData, parallaxPercent: parallax),
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onHorizontalDragStart: _onHorizontalDragStart,
//       onHorizontalDragUpdate: _onHorizontalDragUpdate,
//       onHorizontalDragEnd: _onHorizontalDragEnd,
//       behavior: HitTestBehavior.translucent,
//       child: Stack(
//         children: _buildCards(),
//       ),
//     );
//   }
// }
//
// class Card extends StatefulWidget {
//   Card({@required this.data, this.parallaxPercent = 0.0});
//
//   final CardData data;
//   final double parallaxPercent;
//
//   @override
//   State<StatefulWidget> createState() => _CardState();
// }
//
// class _CardState extends State<Card> with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: <Widget>[
//         ClipRect(
//           child: FractionalTranslation(
//             translation: Offset(widget.parallaxPercent * 2.0, 0.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               child: Image.asset(
//                 widget.data.asset,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class BottomBar extends StatefulWidget {
//   BottomBar({this.cardCount, this.scrollPercent});
//
//   final int cardCount;
//   final double scrollPercent;
//
//   @override
//   State<StatefulWidget> createState() => _BottomBarState();
// }
//
// class _BottomBarState extends State<BottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Center(
//               child: Icon(
//                 Icons.settings,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//               child: Container(
//             width: double.infinity,
//             height: 5.0,
//             child: ScrollIndicator(
//                 cardCount: widget.cardCount,
//                 scrollPercent: widget.scrollPercent),
//           )),
//           Expanded(
//             child: Center(
//               child: Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class ScrollIndicator extends StatelessWidget {
//   ScrollIndicator({this.cardCount, this.scrollPercent});
//
//   final int cardCount;
//   final double scrollPercent;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: ScrollIndicatorPainter(
//           cardCount: cardCount, scrollPercent: scrollPercent),
//       child: Container(),
//     );
//   }
// }
//
// class ScrollIndicatorPainter extends CustomPainter {
//   ScrollIndicatorPainter({this.cardCount, this.scrollPercent})
//       : trackPaint = Paint()
//           ..color = Color(0xFF444444)
//           ..style = PaintingStyle.fill,
//         thumbPaint = Paint()
//           ..color = Colors.white
//           ..style = PaintingStyle.fill;
//
//   final int cardCount;
//   final double scrollPercent;
//   final Paint trackPaint;
//   final Paint thumbPaint;
//
//   @override
//   void paint(ui.Canvas canvas, ui.Size size) {
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(0.0, 0.0, size.width, size.height),
//         topLeft: Radius.circular(3.0),
//         topRight: Radius.circular(3.0),
//         bottomLeft: Radius.circular(3.0),
//         bottomRight: Radius.circular(3.0),
//       ),
//       trackPaint,
//     );
//
//     final thumbWidth = size.width / cardCount;
//     final thumbLeft = scrollPercent * size.width;
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(thumbLeft, 0.0, thumbWidth, size.height),
//         topLeft: Radius.circular(3.0),
//         topRight: Radius.circular(3.0),
//         bottomLeft: Radius.circular(3.0),
//         bottomRight: Radius.circular(3.0),
//       ),
//       thumbPaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
