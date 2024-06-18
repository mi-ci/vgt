import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'random.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'camerapage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  Image? _processedImage;
  List<dynamic>? _classifications;

  Future<void> open() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        File imageFile = File(image.path);

        GlobalKey<CameraPageState> cameraPageKey = GlobalKey<CameraPageState>();

        // Navigate to CameraPage with placeholder loading text
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(
              key: cameraPageKey,
            ),
          ),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await uploadImage(imageFile, cameraPageKey);
        });
      }
    }
  }

  Future<void> uploadImage(
      File imageFile, GlobalKey<CameraPageState> cameraPageKey) async {
    String apiUrl = 'http://172.104.100.179:5000/predict';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files
        .add(await http.MultipartFile.fromPath('frame', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      String base64Image = jsonResponse['image'];
      List<dynamic> classifications = jsonResponse['classifications'];
      _processedImage = Image.memory(base64Decode(base64Image));
      _classifications = classifications;

      // Update the CameraPage with the processed image
      cameraPageKey.currentState?.updateImage(_processedImage!);
      cameraPageKey.currentState?.updateList(_classifications!);
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
  }

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '마녀의 냉장고',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  FadeInDown(
                    from: 100,
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                      width: 230,
                      height: 230,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(510),
                        child: Image.asset('assets/images/main.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FadeInUp(
                    from: 60,
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "어떤 요리를 할지 고민이세요? 저희가 알려드릴게요",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      '재료를 촬영해보세요',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        child: MaterialButton(
                          onPressed: open,
                          minWidth: double.infinity,
                          height: 50,
                          child: Text(
                            "촬영하기",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0), // 여기에 SizedBox를 추가하여 위젯 사이에 간격을 줍니다.
                  FadeInUp(
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
                              MaterialPageRoute(builder: (context) => RecipeRandomizer()),
                            );
                          },
                          minWidth: double.infinity,
                          height: 50,
                          child: Text(
                            "오늘의 추천 레시피",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
      ),
    );
  }
}
