import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package

class RecipeRandomizer extends StatefulWidget {
  @override
  _RecipeRandomizerState createState() => _RecipeRandomizerState();
}

class _RecipeRandomizerState extends State<RecipeRandomizer> {
  List<Map> _products = [];
  int _current = 0;
  Map _selectedIndex = {}; // 선택된 인덱스를 저장하는 맵
  late CarouselController
      _carouselController; // Declare _carouselController with late keyword

  @override
  void initState() {
    super.initState();
    _carouselController =
        CarouselController(); // Initialize _carouselController
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
    List<Map> categoryList = categoryRawList.cast<Map>();
    if (categoryList.length >= 6) {
      categoryList.shuffle();
      _products = categoryList.sublist(0, 6);
    } else {
      _products = categoryList;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                // 선택된 레시피로 다음 단계로 이동하는 코드 추가
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8, // Adjust childAspectRatio for desired size
        ),
        itemCount: _products.length,
        itemBuilder: (BuildContext context, int index) {
          Map recipe = _products[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = _selectedIndex == recipe ? {} : recipe;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(recipe['image'],
                        fit: BoxFit.cover,
                        height: 400 // Adjust height of image as needed
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe['title'],
                          style: TextStyle(
                            fontSize: 18, // Adjust fontSize as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipe['description'],
                          style: TextStyle(
                            fontSize: 14, // Adjust fontSize as needed
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
