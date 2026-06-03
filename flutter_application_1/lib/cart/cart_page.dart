import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/orders/orders_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  List<dynamic> cartItems = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final items = await ApiService.getCart();
      setState(() {
        cartItems = items;
        calculateTotal();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cart: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateTotal() {
    total = cartItems.fold(0, (sum, item) => 
      sum + (double.parse(item['product_price'].toString()) * item['quantity']));
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await ApiService.removeFromCart(productId);
      loadCartItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item from cart')),
      );
    }
  }

  Future<void> _checkout() async {
    try {
      final orderData = {
        'items': cartItems,
        'total_price': total,
      };

      await ApiService.createOrder(orderData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
      
      // Clear cart and navigate to orders page
      setState(() {
        cartItems = [];
        total = 0;
      });
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Dismissible(
                            key: Key(item['cart_id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              removeFromCart(item['product_id']);
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (item['quantity'] > 1) {
                                          ApiService.updateCartQuantity(
                                            item['product_id'],
                                            item['quantity'] - 1,
                                          ).then((_) => loadCartItems());
                                        }
                                      },
                                    ),
                                    Text('${item['quantity']}'),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        ApiService.updateCartQuantity(
                                          item['product_id'],
                                          item['quantity'] + 1,
                                        ).then((_) => loadCartItems());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: \$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: cartItems.isEmpty ? null : _checkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
