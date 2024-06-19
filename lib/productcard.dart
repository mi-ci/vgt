import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'productdetailPage.dart';
import 'package:auto_size_text/auto_size_text.dart'; // 제품 상세 페이지를 import 합니다

class ProductCard extends StatefulWidget {
  final String food;

  ProductCard({required this.food});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  CarouselController _carouselController = CarouselController();

  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final String response = await rootBundle.loadString('assets/recc.json');
    final jsonData = json.decode(response);
    List<String> fooli = widget.food.split(',');
    List<Map<String, dynamic>> products = [];
    for (var i in fooli) {
      var table = jsonData[i];
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
    }
    // final table = jsonData[widget.food];

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
                _selectedProduct = _products[index];
              });
            },
          ),
          items: _products.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    _navigateToDetailPage(product); // 상세 페이지로 이동
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: _selectedProduct == product
                          ? Border.all(color: Colors.transparent, width: 0)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
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
                              tag: 'product_image_${product['title']}',
                              child: Image.asset(product['image'],
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(height: 20),
                          AutoSizeText(
                            product['title'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2, // 예시로 최대 2줄까지 표시될 수 있도록 설정
                            minFontSize: 12, // 최소 글꼴 크기 설정
                            overflow: TextOverflow
                                .ellipsis, // 최대 줄 수를 초과할 경우 '...' 표시
                          ),
                          SizedBox(height: 20),
                          AutoSizeText(
                            product['description'],
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                            maxLines: 3, // 예시로 최대 3줄까지 표시될 수 있도록 설정
                            minFontSize: 10, // 최소 글꼴 크기 설정
                            overflow: TextOverflow
                                .ellipsis, // 최대 줄 수를 초과할 경우 '...' 표시
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
