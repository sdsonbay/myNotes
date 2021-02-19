import 'package:flutter/material.dart';

Widget defaultAppBar(String barTitle) {
  return AppBar(
    backgroundColor: Colors.blueAccent,
    title: Text('$barTitle'),
  );
}
