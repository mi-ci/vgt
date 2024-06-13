import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';

class RecipeRandomizer extends StatefulWidget {
  @override
  _RecipeRandomizerState createState() => _RecipeRandomizerState();
}

class _RecipeRandomizerState extends State<RecipeRandomizer> {
  List<Map> _products = [];
  int _current = 0;
  Map _selectedIndex = {}; // 타입을 Map으로 변경
  CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    loadRecipeData();
  }

  Future<void> loadRecipeData() async {
    String data = await rootBundle.loadString('assets/recc.json');
    _pickRandomRecipe(data);
  }

  void _pickRandomRecipe(String jsonData) {
    var decodedData = jsonDecode(jsonData) as Map;
    var allCategories = decodedData.keys.toList();
    Random random = Random();
    String randomCategory = allCategories[random.nextInt(allCategories.length)];
    List<dynamic> categoryRawList = decodedData[randomCategory];
    List<Map> categoryList = categoryRawList.cast<Map>(); // 타입 캐스팅 추가
    if (categoryList.length >= 3) {
      categoryList.shuffle();
      _products = categoryList.sublist(0, 3);
    } else {
      _products = categoryList;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex.isNotEmpty // Map이 비어있는지 확인
          ? FloatingActionButton(
              onPressed: () {
                // onPressed 함수 구현
                // 예: 선택된 레시피로 다음 단계로 이동하는 코드 추가
                // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
              },
              child: Icon(Icons.arrow_forward_ios),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '오늘의 추천 레시피',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20, // 예시로 추가된 텍스트 스타일링
            fontWeight: FontWeight.bold,
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
            },
          ),
          items: _products.map((recipe) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedIndex == recipe) {
                        _selectedIndex = {};
                      } else {
                        _selectedIndex = recipe;
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: _selectedIndex == recipe
                          ? Border.all(color: Colors.blue.shade500, width: 3)
                          : null,
                      boxShadow: _selectedIndex == recipe
                          ? [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              )
                            ]
                          : [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              )
                            ],
                    ),
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
                            child: Image.asset(
                              recipe['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            recipe['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            recipe['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
