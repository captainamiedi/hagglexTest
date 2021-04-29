import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hagglex'),
        centerTitle: true,
        backgroundColor: Color(0XFF2E1963),
      ),
      body: Text('user dashboard'),
    );
  }
}
