import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(String header)
      : super(
          title: Text(header),
          backgroundColor: Colors.blue,
        );
}
