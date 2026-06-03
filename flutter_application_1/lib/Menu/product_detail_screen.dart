import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final String image;

  ProductDetailScreen({required this.productId, required this.image});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = true;
  Map<String, dynamic>? productData;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadProductDetails();
    checkIfFavorite();
  }

  Future<void> loadProductDetails() async {
    try {
      final data = await ApiService.getProduct(widget.productId);
      setState(() {
        productData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading product details: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product details')),
      );
    }
  }

  Future<void> checkIfFavorite() async {
    try {
      final favorites = await ApiService.getFavorites();
      setState(() {
        isFavorite = favorites.any((item) => item['product_id'] == widget.productId);
      });
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (isFavorite) {
        await ApiService.removeFromFavorites(widget.productId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        await ApiService.addToFavorites(widget.productId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 255, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
        title: Text('Product Details'),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('assets/images/${widget.image}'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name and Brand
                        Text(
                          productData?['product_name'] ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 52, 102, 1.0),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Brand: ${productData?['brand_name'] ?? ''}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        // Price
                        SizedBox(height: 16),
                        Text(
                          '\$${(double.tryParse(productData?['product_price'].toString() ?? '0') ?? 0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(72, 52, 102, 1.0),
                          ),
                        ),
                        
                        // Product Details
                        SizedBox(height: 24),
                        _buildDetailItem('Skin Type', productData?['product_skintype_preference'] ?? ''),
                        _buildDetailItem('Weather Suitability', productData?['product_weather_suitability'] ?? ''),
                        _buildDetailItem('Allergies', productData?['product_allergy'] ?? 'None'),
                        _buildDetailItem('Stock', '${productData?['product_stock'] ?? 0} units'),
                        _buildDetailItem('Quantity', '${productData?['product_quantity'] ?? 0} ml'),
                        
                        // Add to Cart Button
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await ApiService.addToCart(widget.productId, 1);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Product added to cart')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to add to cart: $e')),
                                    );
                                  }
                                },
                                child: Text('Add to Cart'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 30,
                              ),
                              onPressed: toggleFavorite,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(72, 52, 102, 1.0),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 