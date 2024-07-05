import 'package:flutter/material.dart';
import 'package:calculator/bindings/my_bindings.dart';
import 'package:calculator/screen/main_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBindings(),
      title: "Calculator",
      home: MainScreen(),
    );
  }
}
