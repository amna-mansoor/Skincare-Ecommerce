import 'package:flutter/material.dart';
import '../Menu/single_item_screen.dart';
import '../Menu/items_widget.dart';

class RecentlyViewedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recently Viewed"),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          FutureBuilder<List<Product>>(
            future: RecentlyViewedManager.getRecentlyViewedProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No recently viewed products"));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Product product = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/${product.image}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleItemScreen(product.image),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class RecentlyViewedManager {
  static List<Product> _recentlyViewed = [];

  static void addProduct(Product product) {
    _recentlyViewed.remove(product);
    _recentlyViewed.insert(0, product);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed.removeLast();
    }
  }

  static Future<List<Product>> getRecentlyViewedProducts() async {
    // Simulating an async operation
    await Future.delayed(Duration(milliseconds: 500));
    return _recentlyViewed;
  }
}