
// ignore: unused_import
 //import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home1Page extends StatefulWidget {
  const Home1Page({super.key});

  @override
  Home1PageState createState() => Home1PageState();
}

class Home1PageState extends State<Home1Page> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0800),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // màu trong suốt
        leading: const Icon(
          Icons.search,
          color: Color(0xFFFFFFFF),
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/MyStatus.jpg'),
            ),
          ),
        ],
      ),
      body:Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: const Column(
                    children: [
                      CircleAvatar(
                         radius: 30,
                         backgroundImage: AssetImage('assets/images/MyStatus1.jpg'),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text("MyStatus", 
                      style: TextStyle(color: Color(0xFFFFFFFF))
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/Adil1.jpg'), 
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text("Adil", 
                      style: TextStyle(color: Color(0xFFFFFFFF))
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/Marina1.jpg'), 
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text("Marina", 
                      style: TextStyle(color: Color(0xFFFFFFFF))
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                // ignore: avoid_unnecessary_containers
                Container(
                   child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/Dean1.jpg'), 
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text("Dean", 
                      style: TextStyle(color: Color(0xFFFFFFFF))
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                // ignore: avoid_unnecessary_containers
                Container(
                    child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/Dean1.jpg'), 
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text("Dean", 
                      style: TextStyle(color: Color(0xFFFFFFFF))
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                // ignore: avoid_unnecessary_containers
                Container(
                    child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/Max1.jpg'), 
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Text("Max", 
                      style: TextStyle(color: Color(0xFFFFFFFF))
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:  
            Container(
              decoration: const BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                ),
              ),
              child:  ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("More tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Delete tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: const ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('assets/images/AlexLinderson.jpg'),
                          ),
                          title: Text('Alex Linderson'),
                          subtitle: Text('How are you today?'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '2 min ago',
                                style: TextStyle(color: Color(0x797C7B79)),
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                              CircleAvatar(
                                radius: 10,
                                // ignore: use_full_hex_values_for_flutter_colors
                                backgroundColor: Color(0xf04a4cf04a4c),
                                child: Text(
                                  '3',
                                  style: TextStyle(color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("More tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Delete tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child:const ListTile(
                            leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                              AssetImage('assets/images/TeamAlign2.jpg'),
                            ),
                            title: Text('TeamAlign'),
                            subtitle: Text('Don’t miss to attend the meeting.'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('2 min ago' , selectionColor: Color(0x797C7B79),),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                CircleAvatar(
                                  radius: 10,
                                  // ignore: use_full_hex_values_for_flutter_colors
                                  backgroundColor: Color(0xf04a4cf04a4c),
                                  child: Text('4',
                                  style:TextStyle(color: Color(0xFFFFFFFF))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                      // 3
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      //ignore: avoid_unnecessary_containers
                      Container(
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("More tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Delete tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage('assets/images/Adil2.jpg'),
                            ),
                            title: const Text('John Ahraham'),
                            subtitle: const Text('Hey! Can you join the meeting?'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text('2 min ago',
                                    style: TextStyle(color: Color(0x797C7B79))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 2
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("More tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Delete tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                          leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                          AssetImage('assets/images/Marina2.jpg'),
                          ),
                          title: Text('Sabila Sayma'),
                          subtitle: Text('How are you day?'),
                          trailing: Column(
                               children: [
                                Text('2 min ago' , selectionColor: Color(0x797C7B79),)
                               ],
                            ),
                        ),
                      ),
                      ),
                      // 1
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),  
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("More tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Delete tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: const ListTile(
                          leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                          AssetImage('assets/images/Max2.jpg'),
                          ),
                          title: Text('John Borino'),
                          subtitle: Text('Have a good day 🌸'),
                          trailing: Column(
                               children: [
                                Text('2 min ago' , selectionColor: Color(0x797C7B79),)
                               ],
                            ),
                        ),
                      ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("More tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Delete tapped"),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                        child: const ListTile(
                        leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/AngelDayna.jpg'),
                      ),
                      title: Text('AngelDayna'),
                      subtitle: Text('How are you today?'),
                      trailing: Column(
                        children: [
                          Text('2 min ago' , selectionColor: Color(0x797C7B79),)
                        ],
                      ),    
                    ),
                  )
                  )
                ],
              ),
            )
          ),
        ],
      ) ,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          NavigationDestination(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

