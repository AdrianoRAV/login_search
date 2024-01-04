import 'package:flutter/material.dart';

class ApiConsumi extends StatefulWidget {
  const ApiConsumi({super.key});

  @override
  State<ApiConsumi> createState() => _ApiConsumiState();
}

class _ApiConsumiState extends State<ApiConsumi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Cosumindo APIs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
