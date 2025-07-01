// import 'package:flutter/material.dart';
//
// class Test extends StatefulWidget {
//   const Test({super.key});
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   double val = 0.0;
//   double val1 = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Brightness Test Volume Controller"),
//         centerTitle: true,
//       ),
//       body: SliderTheme(
//         data: SliderThemeData(
//           thumbColor: Colors.deepOrange,
//           trackHeight: 10.0,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.brightness_auto_outlined,
//                   color: Colors.red[900],
//                   size: 100,
//                 ),
//                 Icon(
//                   Icons.access_alarm,
//                   color: Colors.red[900],
//                   size: 100,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 60,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Icon(
//                   Icons.volume_mute,
//                   color: Colors.blueAccent,
//                   size: 30,
//                 ),
//                 Slider(
//                   max: 1.0,
//                   min: 0.0,
//                   value: val,
//                   onChanged: (Value) {
//                     setState(() {
//                       val = Value;
//                     });
//                   },
//                 ),
//                 Icon(
//                   Icons.volume_up,
//                   color: Colors.blueAccent,
//                   size: 30,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
//
// class Test extends StatelessWidget {
//   const Test({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           generateBluredImage(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   color: Colors.black,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 1),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: rectShapeContainer(),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(1),
//                 child: Volume(),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget generateBluredImage() {
//     return Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/images/download23.png"),
//               fit: BoxFit.cover)),
//       child: BackdropFilter(
//         filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
//         child: Container(
//           decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
//         ),
//       ),
//     );
//   }
//
//   Widget rectShapeContainer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 0),
//       child: Container(
//         width: 120,
//         height: 160,
//         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.black.withOpacity(0.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black,
//               blurRadius: 5,
//               offset: Offset(3, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child:
//                     Image(image: AssetImage("assets/images/download24.png"))),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget Volume() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 0),
//       child: SliderTheme(
//         data: SliderThemeData(
//           thumbColor: Colors.deepOrange,
//           trackHeight: 10.0,
//         ),
//         child: Column(
//           children: [
//             Icon(Icons.volume_up, color: Colors.white, size: 24),
//             RotatedBox(
//               quarterTurns: -1,
//               child: Slider(
//                 min: 0,
//                 max: 1,
//                 value: val,
//                 onChanged: (value) {
//                   val = value;
//                 },
//                 activeColor: Colors.green,
//                 inactiveColor: Colors.grey,
//               ),
//             ),
//             Icon(Icons.volume_off, color: Colors.white, size: 24),
//           ],
//         ),
//
//       ),
//     );
//   }
// }
//
// double val = 0.5;

// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
//
// class Test extends StatelessWidget {
//   const Test({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           generateBluredImage(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   color: Colors.black,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 1),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: rectShapeContainer(),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(1),
//                 child: Volume(),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget generateBluredImage() {
//     return Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/images/download23.png"),
//               fit: BoxFit.cover)),
//       child: BackdropFilter(
//         filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
//         child: Container(
//           decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
//         ),
//       ),
//     );
//   }
//
//   Widget rectShapeContainer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 0),
//       child: Container(
//         width: 120,
//         height: 160,
//         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.black.withOpacity(0.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black,
//               blurRadius: 5,
//               offset: Offset(3, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child:
//                 Image(image: AssetImage("assets/images/download24.png"))),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget Volume() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 0),
//       child: SliderTheme(
//         data: SliderThemeData(
//           thumbColor: Colors.deepOrange,
//           trackHeight: 10.0,
//         ),
//         child: Column(
//           children: [
//             Icon(Icons.volume_up, color: Colors.white, size: 24),
//             RotatedBox(
//               quarterTurns: -1,
//               child: Slider(
//                 min: 0,
//                 max: 1,
//                 value: val,
//                 onChanged: (value) {
//                   val = value;
//                 },
//                 activeColor: Colors.green,
//                 inactiveColor: Colors.grey,
//               ),
//             ),
//             Icon(Icons.volume_off, color: Colors.white, size: 24),
//             SizedBox( height: 10),
//           ],
//         ),
//
//       ),
//     );
//   }
// }
//
// double val = 0.5;

// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

// class CallVideoPage extends StatefulWidget {
//   const CallVideoPage({super.key});
//   @override
//   State<CallVideoPage> createState() => _CallVideoPageState();
// }
// class _CallVideoPageState extends State<CallVideoPage> {
//   double val = 0.0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           generateBluredImage(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   color: Colors.black,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 1),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: rectShapeContainer(),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(1),
//                 child: Volume(),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//   Widget generateBluredImage() {
//     return Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/images/download23.png"),
//               fit: BoxFit.cover)),
//       child: BackdropFilter(
//         filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
//         child: Container(
//           decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
//         ),
//       ),
//     );
//   }
//   Widget rectShapeContainer() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 0),
//       child: Container(
//         width: 120,
//         height: 160,
//         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.black.withOpacity(0.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black,
//               blurRadius: 5,
//               offset: Offset(3, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child:
//                 Image(image: AssetImage("assets/images/download24.png"))),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget Volume() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 45, horizontal: 20),
//       child: SliderTheme(
//         data: SliderThemeData(
//           thumbColor: Colors.deepOrange,
//           trackHeight: 10.0,
//         ),
//         child: Column(
//           children: [
//             Icon(Icons.volume_up, color: Colors.white, size: 24),
//             RotatedBox(
//               quarterTurns: -1,
//               child: Slider(
//                 min: 0,
//                 max: 1,
//                 value: val,
//                 onChanged: (Value) {
//                   setState(() {
//                     val = Value;
//                   });
//                 },
//                 activeColor: Colors.green,
//                 inactiveColor: Colors.grey,
//               ),
//             ),
//             Icon(Icons.volume_off, color: Colors.white, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CallVideoPage extends StatefulWidget {
  const CallVideoPage({super.key});

  @override
  State<CallVideoPage> createState() => _CallVideoPageState();
}

class _CallVideoPageState extends State<CallVideoPage> {
  double val = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          generateBluredImage(),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                rectShapeContainer(),
                Volume(),
              ]),
          Positioned(
            bottom: 50,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.mic, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 25)),
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 25)),
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.videocam, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 25)),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.chat_bubble, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 25)),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget generateBluredImage() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/download23.png"),
              fit: BoxFit.cover)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget rectShapeContainer() {
    return Padding(
      padding: EdgeInsets.only(left: 300, bottom: 150),
      child: Container(
        width: 120,
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child:
                    Image(image: AssetImage("assets/images/download24.png"))),
          ],
        ),
      ),
    );
  }

  Widget Volume() {
    return Padding(
      padding: EdgeInsets.only(right: 300, top: 50),
      child: SliderTheme(
        data: SliderThemeData(
          thumbColor: Colors.deepOrange,
          trackHeight: 10.0,
        ),
        child: Column(
          children: [
            Icon(Icons.volume_up, color: Colors.white, size: 24),
            RotatedBox(
              quarterTurns: -1,
              child: Slider(
                max: 1,
                min: 0,
                value: val,
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                },
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
              ),
            ),
            Icon(Icons.volume_mute, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
