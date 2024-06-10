import 'dart:math';
import 'package:flutter/material.dart';
import 'productcard.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  Image? _displayedImage;
  late String food;
  var random = Random();
  var foodList = [
    'broccoli',
    'cabbage',
    'carrot',
    'cucumber',
    'pimento',
    'potoato',
    'pumpkin',
    'radish',
    'tomato'
  ];
  @override
  void initState() {
    super.initState();
    final random = Random();
    food = foodList[random.nextInt(foodList.length)];
  }

  void updateImage(Image newImage) {
    setState(() {
      _displayedImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _displayedImage ?? Text('Loading..'),
          ),
          if (_displayedImage != null)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductCard(),
                    ),
                  );
                },
                child: Text("$food 추천요리"),
              ),
            ),
        ],
      ),
    );
  }
}
