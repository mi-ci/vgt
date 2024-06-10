import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'camerapage.dart';

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
  Image? _processedImage;

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
    String apiUrl = 'https://complete-stud-dashing.ngrok-free.app/predict';
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '마녀의 냉장고',
            style: TextStyle(color: Colors.black),
          ),
          // leading: BackButton(
          //   color: Colors.black,
          // ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
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
                        child: Image.asset('assets/images/main.jpg')),
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
                    )),
                SizedBox(
                  height: 10,
                ),
                FadeInUp(
                    from: 30,
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      '재료를 촬영해보세요',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 50,
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
                        // child: MaterialButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ProductCard()));
                        //   },
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
              ],
            ),
          ),
        ));
  }
}
