import 'package:flutter/material.dart';

class TokenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('토큰 페이지'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
          child: Text('처음 페이지로'),
        ),
      ),
    );
  }
}
