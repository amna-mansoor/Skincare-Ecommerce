import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/Menu/product_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool isLoading = true;
  List<dynamic> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final items = await ApiService.getFavorites();
      setState(() {
        favorites = items;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    try {
      await ApiService.removeFromFavorites(productId);
      loadFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove from favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? Center(child: Text('No favorites yet'))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return Dismissible(
                      key: Key(item['product_id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        removeFromFavorites(item['product_id']);
                      },
                      child: Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/images/moisturizer-dry1.jpeg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['product_name']),
                          subtitle: Text('\$${item['product_price']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => removeFromFavorites(item['product_id']),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  productId: item['product_id'],
                                  image: 'moisturizer-dry1.jpeg',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
} 