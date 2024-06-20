import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  // 재료 목록 데이터
  final List<String> ingredients = [
    '당근',
    '토마토',
    '브로콜리',
    '양배추',
    '오이',
    '마늘',
    '양파',
    '감자',
    '무',
    '바나나',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 정보'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  '인식 가능한 재료:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // 재료 목록을 보여주는 ListView
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(ingredients[index]),
                      leading: Icon(Icons.arrow_right),
                    );
                  },
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 30,
                ),
                Text(
                  'Team: DoRanDoRan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '장우진\n배은영\n도규림\n이준영\n조준형\n임태창\n',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'App Version: 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
