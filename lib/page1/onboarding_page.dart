import 'package:chatboxx_app/page1/SocialButton.dart';
import 'package:flutter/material.dart';

class Chatbox extends StatelessWidget {
  const Chatbox({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Stack(
          children: [
            Positioned(
              top: -(w / 3),
              right: 50,
              child: Transform.rotate(
                angle: 50 * 3.14 / 180,
                child: Container(
                  height: w * 1.5,
                  width: w / 5 * 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(200),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 100,
                          spreadRadius: 10,
                          color: const Color(0xFF43116A).withOpacity(0.5))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image(
                                image: AssetImage('assets/images/Cchatbox.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          const Text(
                            'Connect',
                            style: TextStyle(
                                fontSize: 60,
                                color: Color(0xFFFFFFFF),
                                decoration: TextDecoration.none),
                          ),
                          const Text(
                            'friends',
                            style: TextStyle(
                                fontSize: 60,
                                color: Color(0xFFFFFFFF),
                                decoration: TextDecoration.none),
                          ),
                          const Text(
                            'easily &',
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF),
                                decoration: TextDecoration.none),
                          ),
                          const Text(
                            'quickly',
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF),
                                decoration: TextDecoration.none),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Our chat app is the perfect way to stay\n'
                            'connected with friends and family.\n',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xB9C1C1BE),
                                decoration: TextDecoration.none),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SocialLoginButton(
                                      icon: Icons.facebook,
                                      color: Color(0xFF0288D1)),
                                  SizedBox(width: 16),
                                  SocialLoginButton(
                                      icon: Icons.g_mobiledata,
                                      color: Color(0xFFE6A19F)),
                                  SizedBox(width: 16),
                                  SocialLoginButton(
                                      icon: Icons.apple,
                                      color: Color(0xFF1A1A1A)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                    color: Color(0xFFD6E4E0), thickness: 1),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFD6E4E0),
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                    color: Color(0xFFD6E4E0), thickness: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),
                          // Sign-Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                // foregroundColor: const Color(0xFF1A1A1A),
                                backgroundColor: const Color(0xFFFFFFFF),
                              ),
                              child: const Text(
                                'Sign up withn mail',
                                style: TextStyle(
                                  color: Color(0xe0800e0800),
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(38.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Center(
                                child: Text(
                                  'Existing account? Login',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
