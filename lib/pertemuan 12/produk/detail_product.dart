import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:kampus/pertemuan 12/model/Product.dart';
import 'package:kampus/pertemuan 12/service/api_service.dart';
import 'package:kampus/pertemuan 12/produk/add_product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;
  bool _isLoading = false;
  int _purchaseQuantity = 1;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      final updatedProduct = await ApiService.getProductById(_product.id);
      setState(() {
        _product = updatedProduct;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(product: _product),
      ),
    );

    if (result == true) {
      await _loadProductDetails();
    }
  }

  Future<void> _reduceStock() async {
    if (_purchaseQuantity > _product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stok tidak cukup. Tersedia: ${_product.stock}, diminta: $_purchaseQuantity',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProduct = await ApiService.reduceStock(
        _product.id,
        _purchaseQuantity,
      );
      setState(() {
        _product = updatedProduct;
        _isLoading = false;
        _purchaseQuantity = 1;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Stok berhasil dikurangi sebanyak $_purchaseQuantity unit',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengurangi stok: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _incrementQuantity() {
    if (_purchaseQuantity < _product.stock) {
      setState(() {
        _purchaseQuantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_purchaseQuantity > 1) {
      setState(() {
        _purchaseQuantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProduct,
            tooltip: 'Edit produk',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _loadProductDetails,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isRefreshing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Produk
                        Text(
                          _product.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Harga
                        Text(
                          _product.formattedPrice,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),

                        // Status Stok
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _product.stockColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _product.stockColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inventory_2,
                                color: _product.stockColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _product.stockStatus,
                                style: TextStyle(
                                  color: _product.stockColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Deskripsi
                        Text(
                          'Deskripsi Produk',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _product.descriptions,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Informasi Tanggal
                        _buildInfoRow(
                          'Dibuat Pada',
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(_product.createdAt),
                          Icons.calendar_today,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Diperbarui Pada',
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(_product.updatedAt),
                          Icons.update,
                        ),
                        const SizedBox(height: 24),

                        // Bagian Pembelian (jika stok tersedia)
                        if (_product.stock > 0) ...[
                          Divider(color: Colors.grey[300], thickness: 1),
                          const SizedBox(height: 24),
                          Text(
                            'Kurangi Stok',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Jumlah:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: _decrementQuantity,
                                            iconSize: 18,
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(8),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            child: Center(
                                              child: Text(
                                                '$_purchaseQuantity',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: _incrementQuantity,
                                            iconSize: 18,
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 40,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: _reduceStock,
                                          icon: const Icon(
                                            Icons.shopping_cart_checkout,
                                          ),
                                          label: const Text('Kurangi Stok'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProductImage() {
    if (_product.imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: CachedNetworkImage(
          imageUrl: _product.imageUrl,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Gambar tidak dapat dimuat',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Tidak Ada Gambar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
