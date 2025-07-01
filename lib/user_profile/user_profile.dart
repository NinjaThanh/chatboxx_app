import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 130),
            child: Column(children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage("assets/images/jhon.png"),
              ),
              const Text(
                "Jhon Abraham",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const Text(
                "@jhonabraham",
                style: TextStyle(
                    fontSize: 14, color: Colors.grey), // Set text color to gre
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.chat_bubble_outline),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(width: 5),
                IconButton(
                    icon: Icon(Icons.videocam_outlined),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(width: 5),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SizedBox(width: 5),
                IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Display Name",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              const Text(
                                "Jhon Abraham",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ])),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email Address",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              const Text(
                                "jhonabraham20@gmail.com",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ])),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Address",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              const Text(
                                "33 street west subidbazar,sylhet",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ])),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Phone  Number",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              const Text(
                                "(320) 555-0104",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ])),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email Address",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              const Text(
                                "jhonabraham20@gmail.com",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ])),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
