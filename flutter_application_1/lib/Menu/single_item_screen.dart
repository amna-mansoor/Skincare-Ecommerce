import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'items_widget.dart';
import '../profile/recently_viewed_page.dart';

class SingleItemScreen extends StatefulWidget {
  final String img;

  SingleItemScreen(this.img);

  @override
  _SingleItemScreenState createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // Add the current product to recently viewed
    final product = ItemsWidget.products.firstWhere((p) => p.image == widget.img);
    RecentlyViewedManager.addProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Color.fromRGBO(72, 52, 102, 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Image Section
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          "assets/images/${widget.img}",
                          width: MediaQuery.of(context).size.width / 1.2,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                "Image not found",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Title and Description
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Best skincare",
                            style: TextStyle(
                              color: Color.fromRGBO(72, 52, 102, 1.0),
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.img.split('.').first,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(72, 52, 102, 1.0),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Quantity and Price Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Quantity Selector
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color.fromRGBO(72, 52, 102, 1.0).withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      child: Icon(CupertinoIcons.minus, size: 18, color: Color.fromRGBO(72, 52, 102, 1.0)),
                                    ),
                                    SizedBox(width: 10),
                                    Text("$quantity", style: TextStyle(fontSize: 16, color: Color.fromRGBO(72, 52, 102, 1.0))),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Icon(CupertinoIcons.plus, size: 18, color: Color.fromRGBO(72, 52, 102, 1.0)),
                                    ),
                                  ],
                                ),
                              ),
                              // Price
                              Text(
                                "\$${(15.20 * quantity).toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(72, 52, 102, 1.0),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Additional Info
                          Text(
                            "This premium skincare product is designed to nourish and rejuvenate your skin, leaving it feeling soft, smooth, and radiant. Perfect for daily use, it's suitable for all skin types.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Added $quantity item(s) to cart"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                                  backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("Add to Cart"),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Item added to favorites!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.favorite_outline,
                                      color: Color.fromRGBO(72, 52, 102, 1.0),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Item added to wishlist!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.bookmark_border,
                                      color: Color.fromRGBO(72, 52, 102, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}