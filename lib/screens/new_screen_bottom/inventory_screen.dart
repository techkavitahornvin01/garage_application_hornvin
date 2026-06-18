import 'package:hornvin/localization/app_localizations.dart';
// screens/inventory_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> products = [
    Product(
      name: 'Engine Oil',
      quantity: 25,
      minStock: 10,
      price: 450,
      category: 'Lubricants',
    ),
    Product(
      name: 'Brake Pads',
      quantity: 8,
      minStock: 5,
      price: 1200,
      category: 'Brakes',
    ),
    Product(
      name: 'Air Filter',
      quantity: 3,
      minStock: 5,
      price: 350,
      category: 'Filters',
    ),
    Product(
      name: 'Spark Plug',
      quantity: 15,
      minStock: 10,
      price: 180,
      category: 'Electrical',
    ),
    Product(
      name: 'Battery',
      quantity: 2,
      minStock: 3,
      price: 3500,
      category: 'Electrical',
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> categories = [
    'All',
    'Lubricants',
    'Brakes',
    'Filters',
    'Electrical',
  ];

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products.where((product) {
      bool matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      bool matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    int lowStockCount = products.where((p) => p.quantity < p.minStock).length;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(
          context.trText('Inventory Management'),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.primary,
            onPressed: () => _addProduct(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Low Stock Alert Banner
          if (lowStockCount > 0)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.trText(
                        '$lowStockCount item(s) are low on stock! Please reorder.',
                      ),
                      style: GoogleFonts.lato(color: Colors.red.shade700),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showLowStockItems(),
                    child: Text(context.trText('View')),
                  ),
                ],
              ),
            ),

          // Search and Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: context.trText('Search products...'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                          },
                          selectedColor: const Color(
                            0xFFFF6B35,
                          ).withValues(alpha: 0.2),
                          checkmarkColor: const Color(0xFFFF6B35),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Products',
                    products.length.toString(),
                    Icons.inventory,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Low Stock',
                    lowStockCount.toString(),
                    Icons.warning,
                    isWarning: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Total Value',
                    '₹${_calculateTotalValue()}',
                    Icons.currency_rupee,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Products List
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.trText('No products found'),
                          style: GoogleFonts.lato(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProduct(),
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon, {
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWarning ? Colors.red.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isWarning ? Colors.red : const Color(0xFFFF6B35),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            context.trData(value),
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : const Color(0xFF1A237E),
            ),
          ),
          Text(
            context.trData(title),
            style: GoogleFonts.lato(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    bool isLowStock = product.quantity < product.minStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.production_quantity_limits,
                    color: const Color(0xFFFF6B35),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.trData(product.name),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.trData(product.category),
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${product.price}',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF6B35),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isLowStock
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Stock: ${product.quantity}',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: isLowStock
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF1A237E),
                      ),
                      onPressed: () => _editProduct(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteProduct(product),
                    ),
                  ],
                ),
              ],
            ),
            if (isLowStock)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Low stock alert! Only ${product.quantity} left. Minimum required: ${product.minStock}',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _reorderProduct(product),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B35),
                        ),
                        child: Text(context.trText('Reorder')),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (context) => _AddEditProductDialog(
        onSave: (product) => setState(() => products.add(product)),
      ),
    );
  }

  void _editProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => _AddEditProductDialog(
        product: product,
        onSave: (updatedProduct) {
          setState(() {
            int index = products.indexOf(product);
            products[index] = updatedProduct;
          });
        },
      ),
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.trText('Delete Product')),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.trText('Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => products.remove(product));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.trText('Product deleted'))),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.trText('Delete')),
          ),
        ],
      ),
    );
  }

  void _reorderProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.trText('Reorder Product')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reorder ${product.name}?'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed for ${product.name}')),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text(context.trText('Place Order')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLowStockItems() {
    List<Product> lowStock = products
        .where((p) => p.quantity < p.minStock)
        .toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.trText('Low Stock Items')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lowStock.length,
            itemBuilder: (context, index) {
              final product = lowStock[index];
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text(product.name),
                subtitle: Text(
                  'Stock: ${product.quantity}/${product.minStock}',
                ),
                trailing: TextButton(
                  onPressed: () => _reorderProduct(product),
                  child: Text(context.trText('Reorder')),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.trText('Close')),
          ),
        ],
      ),
    );
  }

  double _calculateTotalValue() {
    return products.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }
}

class Product {
  String name;
  int quantity;
  int minStock;
  double price;
  String category;

  Product({
    required this.name,
    required this.quantity,
    required this.minStock,
    required this.price,
    required this.category,
  });
}

class _AddEditProductDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const _AddEditProductDialog({this.product, required this.onSave});

  @override
  State<_AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<_AddEditProductDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Lubricants';

  List<String> categories = ['Lubricants', 'Brakes', 'Filters', 'Electrical'];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _quantityController.text = widget.product!.quantity.toString();
      _minStockController.text = widget.product!.minStock.toString();
      _priceController.text = widget.product!.price.toString();
      _selectedCategory = widget.product!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.trText('Product Name'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: context.trText('Price (₹)'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: context.trText('Quantity'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _minStockController,
                decoration: InputDecoration(
                  labelText: context.trText('Minimum Stock Alert'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: context.trText('Category'),
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.trText('Cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _priceController.text.isNotEmpty) {
              widget.onSave(
                Product(
                  name: _nameController.text,
                  price: double.parse(_priceController.text),
                  quantity: int.parse(_quantityController.text),
                  minStock: int.parse(_minStockController.text),
                  category: _selectedCategory,
                ),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
          ),
          child: Text(context.trText('Save')),
        ),
      ],
    );
  }
}
