import 'package:flutter/material.dart';
import '../order.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;

  CheckoutPage({required this.cartItems, required this.total});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String address = '';
  String phone = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard("Shipping Information", [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                      onSaved: (value) => name = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
                      onSaved: (value) => address = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone'),
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                      onSaved: (value) => phone = value!,
                    ),
                  ]),
                  SizedBox(height: 20),
                  _buildInfoCard("Payment Information", [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Card Number'),
                      validator: (value) => value!.isEmpty ? 'Please enter your card number' : null,
                      onSaved: (value) => cardNumber = value!,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Expiry Date'),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => expiryDate = value!,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'CVV'),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => cvv = value!,
                          ),
                        ),
                      ],
                    ),
                  ]),
                  SizedBox(height: 20),
                  _buildInfoCard("Order Summary", [
                    ...widget.cartItems.map((item) => _buildOrderItem(item.name, item.quantity, item.price)),
                    Divider(),
                    _buildInfoRow("Total", "\$${widget.total.toStringAsFixed(2)}"),
                  ]),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: Text("Place Order"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(72, 52, 102, 1.0),
              ),
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, int quantity, double price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text("$quantity x \$${price.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Create a new Order object
      final newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
        date: DateTime.now().toString(),
        total: widget.total,
        status: 'Pending',
        items: widget.cartItems,
      );
      
      // Here you would typically send the order to your backend
      // For now, we'll just show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }
}