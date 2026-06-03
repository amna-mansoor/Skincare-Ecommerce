import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: "How do I place an order?",
      answer: "To place an order, simply browse our products, add items to your cart, and proceed to checkout. Follow the prompts to enter your shipping and payment information.",
    ),
    FAQItem(
      question: "What payment methods do you accept?",
      answer: "We accept major credit cards (Visa, MasterCard, American Express) and PayPal.",
    ),
    FAQItem(
      question: "How can I track my order?",
      answer: "Once your order has been shipped, you will receive a tracking number via email. You can use this number to track your package on our website or the carrier's website.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support"),
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
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Frequently Asked Questions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...faqItems.map((item) => ExpansionTile(
                title: Text(item.question),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(item.answer),
                  ),
                ],
              )).toList(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Text(
                    "Contact Support",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // TODO: Implement contact support functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Support contact coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}