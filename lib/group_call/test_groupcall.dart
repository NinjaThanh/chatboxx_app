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
              left: 25,
               right: 10,
               child: Row(
                 children: [
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
                 ],
               ),
          ),
        ],
      ),
    );
  }
  Widget generateBluredImage() {
    return Positioned.fill(
      bottom: 160,
      child: Image.asset(
        "assets/images/rectebgle1110.png",
        fit: BoxFit.cover,
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
              Padding(padding: EdgeInsets.all(130)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("assets/images/johnn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("assets/images/johnn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("assets/images/johnn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("assets/images/johnn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("assets/images/johnn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
