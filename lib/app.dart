import 'package:flutter/material.dart';

import 'homescreen.dart';

class App extends StatelessWidget {
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Application',
      home: Scaffold(
        appBar: AppBar(),
        body: HomeScreen(),
      ),
    );
  }
}