import 'package:flutter/material.dart';
import '../order/order_details_page.dart';
import '../order.dart';

class OrderHistoryPage extends StatelessWidget {
  final List<Order> orders = [
    Order(id: "1001", date: "2023-05-01", total: 59.99, status: "Delivered", items: [
      CartItem(name: "Product 1", price: 29.99, quantity: 1),
      CartItem(name: "Product 2", price: 30.00, quantity: 1),
    ]),
    Order(id: "1002", date: "2023-05-15", total: 89.99, status: "Shipped", items: [
      CartItem(name: "Product 3", price: 44.99, quantity: 2),
    ]),
    Order(id: "1003", date: "2023-05-30", total: 29.99, status: "Processing", items: [
      CartItem(name: "Product 4", price: 29.99, quantity: 1),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
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
          ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Order #${orders[index].id}"),
                  subtitle: Text("Date: ${orders[index].date}"),
                  trailing: Text("\$${orders[index].total.toStringAsFixed(2)}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(order: orders[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}