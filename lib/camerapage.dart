import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Spinkit 임포트 추가
import 'productcard.dart';
import 'package:animate_do/animate_do.dart';

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
  bool _isLoading = true; // 로딩 상태 변수 추가

  void updateImage(Image newImage) {
    setState(() {
      _displayedImage = newImage;
      _imageKey = UniqueKey();
      _isLoading = false; // 이미지 업데이트 후 로딩 상태 변경
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
      body: _isLoading // 로딩 중인지 확인
          ? Center(
              child: SpinKitSpinningCircle(
                itemBuilder: (context, index) {
                  return Center(
                    child: Text(
                      "🐶",
                      style: TextStyle(fontSize: 40),
                    ),
                  );
                },
              ),
            )
          //  Center(
          //     child: SpinKitFadingCircle(
          //       // Spinkit을 사용하여 로딩 인디케이터 표시
          //       color: Colors.blue, // 인디케이터 색상 설정
          //       size: 50.0, // 인디케이터 크기 설정
          //     ),
          //   )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: FadeInDown(
                    key: _imageKey,
                    from: 30,
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: _displayedImage ?? Text('Loading..'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (food != null)
                  Center(
                    child: FadeInUp(
                      from: 30,
                      delay: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        '$food가 인식되었네요!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if (food != null)
                  Center(
                    child: FadeInUp(
                      from: 30,
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        '$food로 만들 수 있는 요리를 알아보러갈까요?',
                        style: TextStyle(color: Colors.grey),
                      ),
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
