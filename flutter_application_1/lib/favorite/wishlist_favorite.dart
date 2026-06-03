import 'package:flutter/material.dart';
import 'package:flutter_application_1/Menu/single_item_screen.dart';
import 'package:flutter_application_1/Menu/items_widget.dart';

class FavoritesWishlistPage extends StatefulWidget {
  @override
  _FavoritesWishlistPageState createState() => _FavoritesWishlistPageState();
}

class _FavoritesWishlistPageState extends State<FavoritesWishlistPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Product> favorites = [
    Product(id: 1, name: "Favorite Item 1", image: "moisturizer-dry1.jpeg", description: "A great skincare product", price: 15.99),
    Product(id: 2, name: "Favorite Item 2", image: "moisturizer-dry1.jpeg", description: "Another fantastic product", price: 19.99),
  ];
  List<Product> wishlist = [
    Product(id: 3, name: "Wishlist Item 1", image: "moisturizer-dry1.jpeg", description: "A product you desire", price: 24.99),
    Product(id: 4, name: "Wishlist Item 2", image: "moisturizer-dry1.jpeg", description: "Another must-have item", price: 29.99),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Favorites & Wishlist"),
          backgroundColor: Color.fromRGBO(72, 52, 102, 1.0).withOpacity(0.5),
          bottom: TabBar(
            tabs: [
              Tab(text: "Favorites"),
              Tab(text: "Wishlist"),
            ],
          ),
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
            TabBarView(
              children: [
                _buildProductList(favorites, Icons.favorite, Colors.red),
                _buildProductList(wishlist, Icons.bookmark, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<Product> products, IconData icon, Color color) {
    return products.isEmpty
        ? Center(child: Text("No items yet", style: TextStyle(fontSize: 18, color: Colors.white)))
        : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(products[index].name),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    products.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Item removed")),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Colors.white.withOpacity(0.8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(products[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("\$${products[index].price.toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: Icon(Icons.shopping_cart_outlined, color: Color.fromRGBO(72, 52, 102, 1.0)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to cart")),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SingleItemScreen(products[index].image)),
                      );
                    },
                  ),
                ),
              );
            },
          );
  }
}