import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 650),
        Container(
  height: 80,
  color: const Color.fromARGB(255, 119, 114, 114),
  child: Center(
    child: TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: const BorderSide(color: Colors.white, width: 2), // border color & thickness
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // roundness
        ),
      ),
      onPressed: () {
        print("object");
      },
      child: const Text(
        "Add Image",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
),

      ],
    );
  }
}
