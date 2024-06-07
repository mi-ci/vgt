import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  File? _image;
  Image? _processedImage;

  open() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        File imageFile = File(image.path);
        setState(() {
          _image = imageFile;
        });

        // Create a GlobalKey to access the CameraPage state
        GlobalKey<_CameraPageState> cameraPageKey =
            GlobalKey<_CameraPageState>();

        // Navigate to CameraPage with placeholder loading text
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(
              key: cameraPageKey,
              initialImage: null,
            ),
          ),
        );

        // Upload the image and update the CameraPage with the processed image
        uploadImage(imageFile, cameraPageKey);
      }
    }
  }

  uploadImage(File imageFile, GlobalKey<_CameraPageState> cameraPageKey) async {
    String apiUrl = 'https://ccad-1-233-65-186.ngrok-free.app/predict';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files
        .add(await http.MultipartFile.fromPath('frame', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      _processedImage = Image.memory(responseData);

      // Update the CameraPage with the processed image
      cameraPageKey.currentState?.updateImage(_processedImage!);
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
  }

  // @override
  // void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111), // 어두운 배경 색상
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width > 600 ? 600 : null,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // 그림자 색상
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // 그림자 위치
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '마녀의 냉장고',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontSize: 55,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: open,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // 버튼의 모서리를 조절합니다.
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // 버튼이 비활성화되었을 때
                        }
                        return Colors.red; // 버튼이 활성화되었을 때
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.white; // 텍스트 색상
                      },
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // 화면 너비의 70% 정도의 크기로 버튼을 설정합니다.
                    padding:
                        EdgeInsets.symmetric(vertical: 15), // 버튼의 상하 여백을 추가합니다.
                    child: Center(
                      child: Text('촬영하기'),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print('광고보기 Button pressed ...');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // 버튼의 모서리를 조절합니다.
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // 버튼이 비활성화되었을 때
                        }
                        return Colors.red; // 버튼이 활성화되었을 때
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.white; // 텍스트 색상
                      },
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // 화면 너비의 70% 정도의 크기로 버튼을 설정합니다.
                    padding:
                        EdgeInsets.symmetric(vertical: 15), // 버튼의 상하 여백을 추가합니다.
                    child: Center(
                      child: Text('광고보기'),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print('토큰보기 Button pressed ...');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // 버튼의 모서리를 조절합니다.
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // 버튼이 비활성화되었을 때
                        }
                        return Colors.red; // 버튼이 활성화되었을 때
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.white; // 텍스트 색상
                      },
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // 화면 너비의 70% 정도의 크기로 버튼을 설정합니다.
                    padding:
                        EdgeInsets.symmetric(vertical: 15), // 버튼의 상하 여백을 추가합니다.
                    child: Center(
                      child: Text('토큰보기'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _current = 0;
  dynamic _selectedIndex = {};

  CarouselController _carouselController = new CarouselController();

  List<dynamic> _products = [
    {
      'title': '당근라페',
      'image':
          'https://recipe1.ezmember.co.kr/cache/recipe/2022/02/02/15825af4b03076018a6faa54dfda7a7e1_m.jpg',
      'description': '브런치에 빠지면 섭섭해!'
    },
    {
      'title': '당근수프',
      'image':
          'https://recipe1.ezmember.co.kr/cache/recipe/2017/05/25/b7b2ac2cad2f9aa6baf95731d00bc22a1_m.jpg',
      'description': '부드러운 당근요리'
    },
    {
      'title': '당근수프',
      'image':
          'https://recipe1.ezmember.co.kr/cache/recipe/2016/08/12/bbf561d84d35f13c45ac9f92c271820b1_m.jpg',
      'description': '전기밥솥으로 쉽게!'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex.length > 0
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.arrow_forward_ios),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '추천요리',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
                height: 450.0,
                aspectRatio: 16 / 9,
                viewportFraction: 0.70,
                enlargeCenterPage: true,
                pageSnapping: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: _products.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == movie) {
                          _selectedIndex = {};
                        } else {
                          _selectedIndex = movie;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: _selectedIndex == movie
                              ? Border.all(
                                  color: Colors.blue.shade500, width: 3)
                              : null,
                          boxShadow: _selectedIndex == movie
                              ? [
                                  BoxShadow(
                                      color: Colors.blue.shade100,
                                      blurRadius: 30,
                                      offset: Offset(0, 10))
                                ]
                              : [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: Offset(0, 5))
                                ]),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 320,
                              margin: EdgeInsets.only(top: 10),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.network(movie['image'],
                                  fit: BoxFit.cover),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              movie['title'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              movie['description'],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList()),
      ),
    );
  }
}

// ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ

class CameraPage extends StatefulWidget {
  final Image? initialImage;

  CameraPage({Key? key, this.initialImage}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Image? _displayedImage;

  @override
  void initState() {
    super.initState();
    _displayedImage = widget.initialImage;
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
      body: Center(
        child: _displayedImage ?? Text('Loading..'),
      ),
    );
  }
}
