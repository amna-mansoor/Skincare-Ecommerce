import 'package:flutter/material.dart';
import 'package:flutter_application_1/Menu/home_bottom_bar.dart';
import 'package:flutter_application_1/Menu/items_widget.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/orders/orders_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> skinTypes = ["For you", "Dry", "Oily", "Normal", "Sensitive", "Combination"];
  String currentSkinType = "For you";
  bool isLoading = true;

  @override
  void initState() {
    _tabController = TabController(length: skinTypes.length, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    fetchProducts(currentSkinType);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        currentSkinType = skinTypes[_tabController.index];
        isLoading = true;
      });
      fetchProducts(currentSkinType);
    }
  }

  void fetchProducts(String skinType) async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Get products from API with skin type filter
      final List<dynamic> productList = await ApiService.getProducts(skinType);
      
      // Map the API response to Product objects
      setState(() {
        ItemsWidget.products = productList.map((product) {
          String imageFile = _getImageForProduct(
            product['product_name']?.toLowerCase() ?? '',
            product['product_skintype_preference']?.toLowerCase() ?? ''
          );
          return Product(
            id: product['product_id'],
            name: product['product_name'] ?? '',
            image: imageFile,
            description: """${product['product_skintype_preference'] ?? ''}
${product['brand_name'] ?? ''}""",
            price: double.parse((product['product_price'] ?? 0).toString()),
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
        // Optionally show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: $e')),
        );
      });
    }
  }

  String _getImageForProduct(String productName, String skinType) {
    // Cleansers
    if (productName.contains('cleanser')) {
      if (skinType.contains('dry')) return 'face-cleanser-dry.jpeg';
      if (skinType.contains('combination')) return 'cleanser-combination.jpg';
      if (skinType.contains('sensitive')) return 'cleanser-sensitive-2.jpeg';
      if (skinType.contains('normal')) return 'cleanser-normal.jpg';
      if (skinType.contains('oily')) return 'facewash-combination.jpg';
      return 'cleanser-combination3.jpeg';
    }
    
    // Moisturizers
    if (productName.contains('moisturizer')) {
      if (skinType.contains('dry')) return 'Moisturizing-lotion-dry.png';
      if (skinType.contains('oily')) return 'moisturizer-oily.jpeg';
      if (skinType.contains('sensitive')) return 'moisturizer-sensitive.jpeg';
      if (skinType.contains('combination')) return 'moisturizer-combination2.jpeg';
      return 'moisturizerwithspf-normal2.jpeg';
    }
    
    // Serums
    if (productName.contains('serum')) {
      if (skinType.contains('dry')) return 'vitaminCSerum-dry.png';
      if (skinType.contains('oily')) return 'serum-oily.jpeg';
      if (skinType.contains('sensitive')) return 'eye-serum-sensitive3.jpeg';
      if (skinType.contains('combination')) return 'serum-combination1.jpeg';
      if (skinType.contains('normal')) return 'brightening-serum-normal.jpeg';
      return 'serum-normal2.jpeg';
    }
    
    // Toners
    if (productName.contains('toner')) {
      if (skinType.contains('dry')) return 'toner-dry1.jpeg';
      if (skinType.contains('oily')) return 'toner-oily2.jpeg';
      if (skinType.contains('sensitive')) return 'toner-sensitive.jpg';
      if (skinType.contains('combination')) return 'toner-combination2.jpeg';
      if (skinType.contains('normal')) return 'toner-normal.jpg';
      return 'toner-normal3.jpeg';
    }

    // Face creams and other products
    if (skinType.contains('dry')) return 'moisturizer-dry.png';
    if (skinType.contains('oily')) return 'face-cream-oily3.jpeg';
    if (skinType.contains('sensitive')) return 'sunscreen-senstive.jpeg';
    if (skinType.contains('combination')) return 'spot-treatment-combination.jpeg';
    if (skinType.contains('normal')) return 'serum-normal.jpg';
    
    // Final fallback
    return 'photo-1670201203326-8b4f88e4a5e9.jpeg';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image5.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: ListView(
                children: [
                  // Search Bar and Notifications
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                prefixIcon: Icon(Icons.search, color: Color.fromRGBO(72, 52, 102, 1.0)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_none,
                            color: Color.fromRGBO(72, 52, 102, 1.0),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Welcome Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello! Welcome back!",
                          style: TextStyle(
                            color: Color.fromRGBO(72, 52, 102, 1.0),
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrdersPage()),
                            );
                          },
                          icon: Icon(Icons.shopping_bag),
                          label: Text('My Orders'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(254, 254, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sale Banner
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(72, 52, 102, 1.0).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🎉 Big Sale Alert!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Get up to 50% off on all skincare products this weekend.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: Color.fromRGBO(72, 52, 102, 1.0),
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    isScrollable: true,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromRGBO(72, 52, 102, 1.0),
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    labelPadding: EdgeInsets.symmetric(horizontal: 20),
                    tabs: skinTypes.map((type) => Tab(text: type)).toList(),
                  ),

                  SizedBox(height: 10),

                  // Products Grid
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(72, 52, 102, 1.0),
                          ),
                        )
                      : ItemsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}

