import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'productdetailPage.dart'; // 제품 상세 페이지를 import 합니다

class ProductCard extends StatefulWidget {
  final String food;

  ProductCard({required this.food});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _current = 0;
  dynamic _selectedIndex = {};
  CarouselController _carouselController = CarouselController();

  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/recc.json');
    final jsonData = json.decode(response);
    final table = jsonData[widget.food];
    List<Map<String, dynamic>> products = [];

    for (var entry in table) {
      String title = entry['title'];
      String image = entry['image'];
      String description = entry['description'];

      products.add({
        'title': title,
        'image': image,
        'description': description,
      });
    }

    setState(() {
      _products = products;
    });
  }

  void _navigateToDetailPage(Map<String, dynamic> product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.arrow_forward_ios),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '${widget.food} 추천요리',
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
            },
          ),
          items: _products.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedIndex == product) {
                        _selectedIndex = {};
                      } else {
                        _selectedIndex = product;
                        _navigateToDetailPage(product); // 상세 페이지로 이동
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: _selectedIndex == product
                          ? Border.all(color: Colors.blue.shade500, width: 3)
                          : null,
                      boxShadow: _selectedIndex == product
                          ? [
                              BoxShadow(
                                  color: Colors.blue.shade100,
                                  blurRadius: 30,
                                  offset: Offset(0, 10)),
                            ]
                          : [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 5)),
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
                            child: Hero(
                              tag:
                                  'product_image_${product['title']}', // 각 제품 이미지에 대한 고유 태그
                              child: Image.asset(product['image'],
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            product['title'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            product['description'],
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
          }).toList(),
        ),
      ),
    );
  }
}
