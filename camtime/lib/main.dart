import 'package:camtime/frontend/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UselessProject',        
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text("CamBuddy",style: TextStyle(fontStyle: FontStyle.italic),)),),
        body: Homepage(),
        bottomNavigationBar: BottomAppBar(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_filled),
            Text("Home"),
          ],
        ),
      ),
      InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded),
            Text("About"),
          ],
        ),
      ),
    ],
  ),
), 
        ) ,
    );
  }
}
