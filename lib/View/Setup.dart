import 'package:flutter/material.dart';

class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1963),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 215),
            Image.asset('assets/setup.png'),
            SizedBox(height: 20),
            Text(
              'Setup Complete',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for setting up your HaggleX account',
              style: TextStyle(fontSize: 9.0, color: Colors.white),
            ),
            SizedBox(height: 250),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: SizedBox(
                  child: Container(
                    height: 50.0,
                    // width: 303.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFFFFC175),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'START EXPLORING',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          // ],
          // ),
          ),
    );
  }
}
