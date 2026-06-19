import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/Product.dart';

class ApiService {
  // FIX EMULATOR: Mengubah localhost menjadi 10.0.2.2 agar Android bisa mengakses Laragon PC
  static const String baseUrl = 'http://localhost:8000/api';
  static const String storageUrl = 'http://localhost:8000/storage';

  // FIX LENGKAP: Mengubah imagePath dari database menjadi URL utuh yang valid untuk Android
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';

    String cleanPath = imagePath.trim();

    // 1. Jika backend mengembalikan URL lengkap (misal: mengandung http:// atau https://)
    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      // Ubah kata 'localhost' menjadi IP emulator '10.0.2.2' agar gambar bisa terunduh di HP/Emulator
      if (cleanPath.contains('localhost')) {
        cleanPath = cleanPath.replaceAll('localhost', '10.0.2.2');
      }
      return cleanPath;
    }

    // 2. Jika backend hanya mengembalikan path relatif (misal: "products/nama_file.jpg")
    if (cleanPath.startsWith('storage/')) {
      cleanPath = cleanPath.substring(8);
    }

    if (!cleanPath.startsWith('products/') &&
        !cleanPath.startsWith('/products/')) {
      if (!cleanPath.startsWith('/')) {
        cleanPath = 'products/$cleanPath';
      } else {
        cleanPath = 'products$cleanPath';
      }
    }

    if (!cleanPath.startsWith('/')) {
      cleanPath = '/$cleanPath';
    }

    print('========== IMAGE DEBUG ==========');
    print('Original: $imagePath');
    print('Cleaned Path: $cleanPath');
    print('Final Target URL: $storageUrl$cleanPath');
    print('==================================');

    return '$storageUrl$cleanPath';
  }

  // GET PRODUCTS
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          return decoded.map((json) => Product.fromJson(json)).toList();
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            return (decoded['data'] as List)
                .map((json) => Product.fromJson(json))
                .toList();
          } else if (decoded.containsKey('products') &&
              decoded['products'] is List) {
            return (decoded['products'] as List)
                .map((json) => Product.fromJson(json))
                .toList();
          } else if (decoded.containsKey('result') &&
              decoded['result'] is List) {
            return (decoded['result'] as List)
                .map((json) => Product.fromJson(json))
                .toList();
          } else {
            return [Product.fromJson(decoded)];
          }
        } else {
          throw Exception(
            'Format response tidak dikenali: ${decoded.runtimeType}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint tidak ditemukan: $baseUrl/products');
      } else {
        throw Exception('Gagal memuat produk: ${response.statusCode}');
      }
    } catch (e) {
      print('X Error getProducts: $e');
      throw Exception('Error: $e');
    }
  }

  // GET PRODUCT BY ID
  static Future<Product> getProductById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map) {
            return Product.fromJson(decoded['data']);
          }
          return Product.fromJson(decoded);
        } else {
          throw Exception('Format response tidak dikenali');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Produk tidak ditemukan');
      } else {
        throw Exception('Gagal memuat produk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // REDUCE STOCK - FIXED METHOD (.patch)
  static Future<Product> reduceStock(int productId, int quantity) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/products/$productId/reduce-stock'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'quantity': quantity}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map) {
            return Product.fromJson(decoded['data']);
          }
        }
        return Product.fromJson(decoded);
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Stok tidak mencukupi');
      } else {
        throw Exception('Gagal mengurangi stok: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE PRODUCT
  static Future<void> deleteProduct(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus produk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // CREATE PRODUCT
  static Future<Product> createProduct({
    required String name,
    required String descriptions,
    required int price,
    required int stock,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products'),
      );

      request.headers['Accept'] = 'application/json';

      request.fields['name'] = name;
      request.fields['descriptions'] = descriptions;
      request.fields['price'] = price.toString();
      request.fields['stock'] = stock.toString();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
        print('Create Product: Gambar ditambahkan via File Path');
      } else if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: 'product_${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
        print('Create Product: Gambar ditambahkan via Bytes');
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final responseBody = await streamedResponse.stream.bytesToString();

      print('Create Product Response Status: ${streamedResponse.statusCode}');
      print('Create Product Response Body: $responseBody');

      if (streamedResponse.statusCode == 201 ||
          streamedResponse.statusCode == 200) {
        final decoded = json.decode(responseBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map) {
            return Product.fromJson(decoded['data']);
          }
        }
        return Product.fromJson(decoded);
      } else {
        try {
          final error = json.decode(responseBody);
          throw Exception(error['message'] ?? 'Gagal membuat produk');
        } catch (e) {
          throw Exception(
            'Gagal membuat produk: ${streamedResponse.statusCode}',
          );
        }
      }
    } catch (e) {
      print('Create Product Error: $e');
      throw Exception('Error: $e');
    }
  }

  // UPDATE PRODUCT
  static Future<Product> updateProduct({
    required int id,
    String? name,
    String? descriptions,
    int? price,
    int? stock,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products/$id'),
      );

      request.headers['Accept'] = 'application/json';
      request.fields['_method'] = 'PUT';

      if (name != null && name.isNotEmpty) request.fields['name'] = name;
      if (descriptions != null) request.fields['descriptions'] = descriptions;
      if (price != null) request.fields['price'] = price.toString();
      if (stock != null) request.fields['stock'] = stock.toString();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      } else if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: 'product_${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Update Product Response Status: ${response.statusCode}');
      print('Update Product Response Body: $responseBody');

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map) {
            return Product.fromJson(decoded['data']);
          }
        }
        return Product.fromJson(decoded);
      } else {
        try {
          final error = json.decode(responseBody);
          throw Exception(error['message'] ?? 'Gagal update produk');
        } catch (e) {
          throw Exception('Gagal update produk: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Update Product Error: $e');
      throw Exception('Error: $e');
    }
  }

  // UPLOAD IMAGE
  static Future<String> uploadImage(int productId, File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('File tidak ditemukan');
      }

      final bytes = await imageFile.readAsBytes();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products/$productId/upload-image'),
      );

      request.headers['Accept'] = 'application/json';

      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: 'product_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        return decoded['image_url'] ?? '';
      } else {
        throw Exception('Upload gagal: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }
}
