import 'package:flutter/material.dart';

class Groupcall extends StatefulWidget {
  const Groupcall({super.key});

  @override
  State<Groupcall> createState() => _GroupcallState();
}

class _GroupcallState extends State<Groupcall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Stack(
          fit: StackFit.loose,
          children: [
            generateBluredImage(),
            rectShapeContainer(),
            Positioned(
              bottom: 200,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  CircleAvatar(
                    backgroundColor: Colors.grey[600],
                    radius: 30,
                    child: IconButton(
                      icon: Icon(Icons.mic, color: Color(0xFFFFFFFF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  CircleAvatar(
                    backgroundColor: Colors.grey[600],
                    radius: 30,
                    child: IconButton(
                      icon: Icon(Icons.volume_up, color: Color(0xFFFFFFFF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  CircleAvatar(
                    backgroundColor: Colors.grey[600],
                    radius: 30,
                    child: IconButton(
                      icon: Icon(Icons.videocam, color: Color(0xFFFFFFFF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 30,
                    child: IconButton(
                      icon: Icon(Icons.chat_bubble, color: Color(0xFFFFFFFF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  CircleAvatar(
                    backgroundColor: Color(0xE5BD0918),
                    radius: 30,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Color(0xFFFFFFFF)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),

                ],
              ),
            ),
          ],
        ),
    );
  }
  Widget generateBluredImage() {
    return Padding(
      padding: EdgeInsets.only(bottom: 160),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/rectebgle1110.png"),
              fit: BoxFit.cover,)),
      ),
    );
  }
  Widget rectShapeContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25 ,  ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Meeting with Lora Adom",
            selectionColor: Color(0xFFFFFFFF),
            style: TextStyle(fontSize: 60),
          ),
          Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/marie.png"),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lora Adom",
                          selectionColor: Color(0xFFFFFFFF),
                        ),
                        Text(
                          "Meeting organizer",
                          selectionColor: Color(0xDFE6F3DF),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(50)),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/handsome.png"),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dean Ronload",
                          selectionColor: Color(0xFFFFFFFF),
                        ),
                        Text(
                          "Sounds resonable",
                          selectionColor: Color(0xDFE6F3DF),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/annei.png"),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Annei Ellison",
                          selectionColor: Color(0xFFFFFFFF),
                        ),
                        Text(
                          "What about our profit?",
                          selectionColor: Color(0xDFE6F3DF),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/johnn.png"),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John Borino",
                          selectionColor: Color(0xFFFFFFFF),
                        ),
                        Text(
                          "What led you to this thought?",
                          selectionColor: Color(0xDFE6F3DF),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Stack(
               children: [
                 Positioned(
                   top: 0,
                   left: 0,
                   child: Container(
                     padding: EdgeInsets.all(4),
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       border:Border.all(
                         color: Colors.white,
                         width: 3,
                       )
                     ),
                     child: CircleAvatar(
                       radius: 35,
                       backgroundImage: AssetImage("x.p"),
                     ),
                   ),
                 ),
                 Positioned(
                   bottom: 0,
                   right: 0,
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                     ),
                     padding: EdgeInsets.all(6),
                     child: Icon(
                       Icons.mic_off,
                       size: 18,
                       color: Colors.white,
                     ),
                   ),
                 )
              ],
              ),
           ],
          ),
        ],
      ),
    );
  }
}
