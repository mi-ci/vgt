import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animate_do/animate_do.dart';
import 'productcard.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  Image? _displayedImage;
  List? _displayedList;
  late String food;
  Key _imageKey = UniqueKey();
  bool _isLoading = true;

  void updateImage(Image newImage) {
    setState(() {
      _displayedImage = newImage;
      _imageKey = UniqueKey();
      _isLoading = false;
    });
  }

  void updateList(List newList) {
    setState(() {
      _displayedList = newList;
      food = _displayedList
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(' ', '')
          .toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: Stack(
        children: [
          // 배경 이미지 설정
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets3/vg.jpg'), // 여기에 사용할 이미지 경로를 넣어주세요
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                    BlendMode.dstATop), // 여기서 투명도 조절
              ),
            ),
          ),
          Center(
            child: _isLoading
                ? SpinKitSpinningCircle(
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                          "🍽️",
                          style: TextStyle(fontSize: 40),
                        ),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeInDown(
                        key: _imageKey,
                        from: 30,
                        delay: Duration(milliseconds: 500),
                        duration: Duration(milliseconds: 1000),
                        child: _displayedImage ?? Text('Loading..'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (food != null)
                        FadeInUp(
                          from: 30,
                          delay: Duration(milliseconds: 800),
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            '$food가 인식되었네요!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (food != null)
                        FadeInUp(
                          delay: Duration(milliseconds: 1500),
                          duration: Duration(milliseconds: 1000),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductCard(food: food),
                                    ),
                                  );
                                },
                                minWidth: double.infinity,
                                height: 50,
                                child: Text(
                                  "추천 요리 보러가기",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
