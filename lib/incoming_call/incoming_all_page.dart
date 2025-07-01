import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class IncomingAllPage extends StatelessWidget {
  const IncomingAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          generateBluredImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              rectShapeContainer(),
              actionButtons(),
              call(),
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
              image: AssetImage("assets/images/download22.png"),
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
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: 120,
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
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
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/de.png"),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Borsha Akther",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              "Incoming Call",
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Icon(Icons.access_alarm, color: Colors.white),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text("Remind me",
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 160)),
        Column(
          children: [
            Icon(Icons.messenger_sharp, color: Colors.white),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text("Messenger",
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ]),
    );
  }

  Widget call() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withOpacity(0.3),
              ),
              child: ActionSlider.standard(
                sliderBehavior: SliderBehavior.stretch,
                width: 350,
                backgroundColor: Colors.green.withOpacity(0.2),
                toggleColor: Colors.white,
                height: 60,
                icon: Icon(Icons.phone),
                action: (controller) async {
                  controller.loading();
                  await Future.delayed(const Duration(seconds: 3));
                  controller.success();
                  await Future.delayed(const Duration(seconds: 1));
                  controller.reset();
                },
                child: Text(
                  "slide to answer",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
