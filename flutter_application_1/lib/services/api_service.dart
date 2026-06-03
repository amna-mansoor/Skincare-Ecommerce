import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  //static const String baseUrl = 'http://10.0.2.2:3000'; // For Android Emulator
 // static const String baseUrl = 'http://localhost:3000'; // For iOS Simulator
 static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
      
    } else {
      return 'http://10.0.2.2:3000';
    }
  }

    static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Sending login request to: $baseUrl/auth/login');
      print('Login attempt for email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please try again.');
        },
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
          return data; // Return just the data without success flag
        }
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email or password. Please try again.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      print('Login error in ApiService: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      print('Sending registration request to: $baseUrl/auth/register');
      print('Registration data: ${json.encode(userData)}');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please try again.');
        },
      );

      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return data;
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Registration failed. Please try again.');
      } else {
        throw Exception('Registration failed. Please try again.');
      }
    } catch (e) {
      print('Registration error in ApiService: $e');
      if (e is Exception) {
        throw e;
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


  static Future<Map<String, dynamic>> updateAdditionalInfo(Map<String, dynamic> additionalInfo) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('Sending additional info update request: ${json.encode(additionalInfo)}');

      final response = await http.put(
        Uri.parse('$baseUrl/auth/additional-info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(additionalInfo),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update additional info');
      }
    } catch (e) {
      print('Additional info update error: $e');
      throw Exception('Failed to update additional info: $e');
    }
  }

  // Products
  static Future<List<dynamic>> getProducts([String? skinType]) async {
    try {
      String url = '$baseUrl/products';
      if (skinType != null && skinType.toLowerCase() != 'for you') {
        url += '?skinType=${Uri.encodeComponent(skinType)}';
      }
      
      print('Fetching products from URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final products = json.decode(response.body);
        print('Decoded products: $products');
        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getProducts: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  static Future<Map<String, dynamic>> getProduct(int id) async {
    try {
      print('Fetching product details for ID: $id');
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getProduct: $e');
      throw Exception('Failed to load product: $e');
    }
  }

  // Cart
  static Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'product_id': productId, 'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  static Future<List<dynamic>> getCart() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Favorites and Wishlist
  static Future<List<dynamic>> getFavorites() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  static Future<List<dynamic>> getWishlist() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/wishlist'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load wishlist');
    }
  }

  // Orders
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(orderData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create order');
    }
  }

  static Future<List<dynamic>> getOrderHistory() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/orders/history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load order history');
    }
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  static Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  static Future<void> deleteProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.delete(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete profile');
      }
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  // Customer Support
  static Future<Map<String, dynamic>> submitSupportTicket(String description) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/support/ticket'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'description': description}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit support ticket');
    }
  }

  // Recently Viewed
  static Future<List<dynamic>> getRecentlyViewed() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/recently-viewed'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently viewed items');
    }
  }

  static Future<void> addToRecentlyViewed(int productId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/recently-viewed'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to recently viewed');
    }
  }

  static Future<void> removeFromCart(int productId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from cart');
    }
  }

  static Future<void> updateCartQuantity(int productId, int quantity) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/cart/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart quantity');
    }
  }

  static Future<void> addToFavorites(int productId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/favorites/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorites');
    }
  }

  static Future<void> removeFromFavorites(int productId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }
}
