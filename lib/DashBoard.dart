import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var sample = {};

  getallproduct() async {
    final response = await http.get(Uri.parse(
        "http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      sample = json.decode(response.body);
      print(sample);
    }
  }

  @override
  void initState() {
    super.initState();
    getallproduct();
  }

  @override
  Widget build(BuildContext context) {
    List<String> banners = [];
    if (sample['data'] != null && sample['data']['banner_one'] != null) {
      banners = List<String>.from(
        sample['data']['banner_one'].map((item) => item['banner']),
      );
    }

    List<Map<String, dynamic>> categories = [];
    if (sample['data'] != null && sample['data']['category'] != null) {
      categories = List<Map<String, dynamic>>.from(sample['data']['category']);
    }
    List<Map<String, dynamic>> products = [];
    if (sample['data'] != null && sample['data']['products'] != null) {
      products = List<Map<String, dynamic>>.from(sample['data']['products']);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search here',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/logo.jpeg', width: 20, height: 20),
                ),
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16)
              )
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white,
        ),
        floatingActionButton: Container(
          width: 120, // Adjust width as needed
          height: 50, // Adjust height as needed
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Adjust the radius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat, color: Colors.white),
                SizedBox(width: 5),
                Text("Chat", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: sample.isEmpty?Center(child: CircularProgressIndicator()):
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.network(
                        banners[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
      
            // KYC Pending Section
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Column(
                children: [
                  Text(
                    'KYC Pending',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'You need to provide the required documents for your account activation.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Click Here',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
      
            // Category Icons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories.map((category) {
                  return CategoryIcon(
                    iconUrl: category['icon'],
                    label: category['label'],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
      
            Container(
              color: Colors.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EXCLUSIVE FOR YOU',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.black),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length, // Adjust the number of items as needed
                      itemBuilder: (context, index) {
                        return ProductCard(
                          imageUrl: products[index]['icon'],
                          discount: products[index]['offer']+ 'Off',
                          name:products[index]['label'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer), label: 'Deals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
            iconSize: 24,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey
        ),
      ),
    );
  }
}

// Custom Widget for Category Icon
class CategoryIcon extends StatelessWidget {
  final String iconUrl;
  final String label;

  const CategoryIcon({Key? key, required this.iconUrl, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          iconUrl,
          width: 40, // Adjust width as needed
          height: 40,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Custom Widget for Product Card
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String discount;
  final String name;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.discount,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: 150, // Width for each product card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discount,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
