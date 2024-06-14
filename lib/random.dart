import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';
import 'recipedetailPage.dart';

class RecipeRandomizer extends StatefulWidget {
  @override
  _RecipeRandomizerState createState() => _RecipeRandomizerState();
}

class _RecipeRandomizerState extends State<RecipeRandomizer> {
  List<Map<String, dynamic>> _products = [];
  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    loadRecipeData();
  }

  Future<void> loadRecipeData() async {
    String data = await rootBundle.loadString('assets/recc.json');
    _pickRandomRecipe(data);
  }

  void _pickRandomRecipe(String jsonData) {
    var decodedData = jsonDecode(jsonData) as Map<String, dynamic>;
    var allCategories = decodedData.keys.toList();
    List<String> category1 = [];
    Random random = Random();
    category1.add(allCategories[random.nextInt(9)]);
    category1.add(allCategories[random.nextInt(9)]);
    category1.add(allCategories[random.nextInt(9)]);
    category1.add(allCategories[random.nextInt(9)]);
    List<Map<String, dynamic>> selectedRecipes = [];

    for (String category in category1) {
      List<dynamic> categoryRecipes = decodedData[category];
      if (categoryRecipes.isNotEmpty) {
        selectedRecipes
            .add(categoryRecipes[random.nextInt(categoryRecipes.length)]);
      }
    }

    setState(() {
      _products = selectedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height / 2.5;
    final double itemWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
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
          childAspectRatio: itemWidth / itemHeight,
        ),
        itemCount: _products.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> recipe = _products[index];
          String heroTag = 'recipe_image_${recipe['title']}'; // Hero 태그 생성

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailPage(recipe: recipe, heroTag: heroTag),
                ),
              );
            },
            child: Hero(
              tag: heroTag, // 각 레시피에 대한 고유한 태그 사용
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
                      child: Image.asset(
                        recipe['image'] ?? '',
                        fit: BoxFit.cover,
                        height: itemHeight * 0.6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['title'] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            recipe['description'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
