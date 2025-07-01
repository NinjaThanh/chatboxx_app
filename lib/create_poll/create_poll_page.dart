import 'package:flutter/material.dart';

class CreatePollPage extends StatelessWidget {
  const CreatePollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Poll"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Text(
            "What would you like to  work?",
            style: TextStyle(fontSize: 54),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            child: Row(),
          ),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
