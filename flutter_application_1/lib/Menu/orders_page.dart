import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isLoading = true;
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final orderHistory = await ApiService.getOrderHistory();
      setState(() {
        orders = orderHistory;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text('No orders yet'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ExpansionTile(
                        title: Text('Order #${order['order_id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${order['order_date']}'),
                            Text('Status: ${order['order_status']}'),
                            Text('Total: \$${order['total_price']}'),
                          ],
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order['items'].length,
                            itemBuilder: (context, itemIndex) {
                              final item = order['items'][itemIndex];
                              return ListTile(
                                title: Text(item['product_name']),
                                subtitle: Text('Quantity: ${item['quantity']}'),
                                trailing: Text('\$${item['product_price']}'),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}