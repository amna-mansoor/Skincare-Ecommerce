import 'package:flutter/material.dart';
import '../order.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard("Order Information", [
                  _buildInfoRow("Order ID", "#${order.id}"),
                  _buildInfoRow("Date", order.date),
                  _buildInfoRow("Total", "\$${order.total.toStringAsFixed(2)}"),
                  _buildInfoRow("Status", order.status),
                ]),
                SizedBox(height: 20),
                _buildInfoCard("Shipping Address", [
                  _buildInfoRow("Name", "John Doe"),
                  _buildInfoRow("Address", "123 Main St, Anytown, ST 12345"),
                  _buildInfoRow("Phone", "(123) 456-7890"),
                ]),
                SizedBox(height: 20),
                _buildInfoCard("Payment Information", [
                  _buildInfoRow("Method", "Credit Card"),
                  _buildInfoRow("Card", "**** **** **** 1234"),
                ]),
                SizedBox(height: 20),
                _buildInfoCard("Order Items", [
                  _buildOrderItem("Product 1", 2, 29.99),
                  _buildOrderItem("Product 2", 1, 19.99),
                  _buildOrderItem("Product 3", 3, 9.99),
                ]),
              ],
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
}