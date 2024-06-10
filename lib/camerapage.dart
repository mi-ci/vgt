import 'dart:math';
import 'package:flutter/material.dart';
import 'productcard.dart';
import 'package:animate_do/animate_do.dart';

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
    'potato',
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
          SizedBox(
            height: 10,
          ),
          if (_displayedImage != null)
            Center(
                child: FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      '$food가 인식되었네요!',
                      style: TextStyle(color: Colors.grey),
                    ))),
          SizedBox(
            height: 10,
          ),
          if (_displayedImage != null)
            Center(
                child: FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      '$food로 만들 수 있는 요리를 알아보러갈까요?',
                      style: TextStyle(color: Colors.grey),
                    ))),
          SizedBox(
            height: 10,
          ),
          if (_displayedImage != null)
            FadeInUp(
              delay: Duration(milliseconds: 1500),
              duration: Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductCard(food: food),
                        ),
                      );
                    },
                    minWidth: double.infinity,
                    height: 50,
                    child: Text(
                      "추천 요리 보러가기",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
