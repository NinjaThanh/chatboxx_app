import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Test extends StatelessWidget {
  const Test({super.key});

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
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1),
                child: Align(
                  alignment: Alignment.topRight,
                  child: rectShapeContainer(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1),
                child: Volume(),
              )
            ],
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
      padding: EdgeInsets.symmetric(vertical: 0),
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
      padding: EdgeInsets.symmetric(vertical: 0),
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
                min: 0,
                max: 1,
                value: val,
                onChanged: (value) {
                  val = value;
                },
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
              ),
            ),
            Icon(Icons.volume_off, color: Colors.white, size: 24),
            SizedBox( height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.volume_mute,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                Slider(
                  max: 1.0,
                  min: 0.0,
                  value: val,
                  onChanged:  (value) {
                    val = value;
                  },
                ),
                Icon(
                  Icons.volume_up,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}

double val = 0.5;




