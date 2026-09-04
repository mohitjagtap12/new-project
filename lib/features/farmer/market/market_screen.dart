import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/search_bar.dart';

class MarketScreen extends StatefulWidget {
  final VoidCallback onSelectCrops;
  final VoidCallback onSelectProducts;
  final VoidCallback onSelectWaste;
  final VoidCallback onSelectContracts;

  const MarketScreen({
    Key? key,
    required this.onSelectCrops,
    required this.onSelectProducts,
    required this.onSelectWaste,
    required this.onSelectContracts,
  }) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Crops',
    'Farm Products',
    'Farm Waste',
    'Farm Contracts',
    'Buyer Needs',
  ];

  final List<Map<String, dynamic>> _mockMarketItems = [
    {
      'title': 'Tomato Grade A',
      'category': 'Crops',
      'price': '₹25/kg',
      'location': 'Pune Mandi',
      'qty': '500 kg',
      'type': 'crop',
      'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Sharbati Wheat',
      'category': 'Crops',
      'price': '₹32/kg',
      'location': 'Nashik APMC',
      'qty': '2000 kg',
      'type': 'crop',
      'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Organic Bio-Fertilizer',
      'category': 'Farm Products',
      'price': '₹650/bag',
      'location': 'Pune',
      'qty': '80 bags',
      'type': 'product',
      'image': 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Dry Baled Wheat Straw',
      'category': 'Farm Waste',
      'price': '₹4/kg',
      'location': 'Baramati',
      'qty': '1000 kg',
      'type': 'waste',
      'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'ABC Foods Buy Requirement',
      'category': 'Buyer Needs',
      'price': '₹30/kg',
      'location': 'Pune Food Park',
      'qty': '1000 kg Tomato',
      'type': 'contract',
      'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _mockMarketItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item['category'] == _selectedCategory;
      final matchesQuery = item['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['location'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: AgroSearchBar(
              hintText: 'Search here...',
              showFilter: true,
              onChanged: (val) => setState(() => _searchQuery = val),
              onFilterTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Market Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: ['All Locations', 'Pune', 'Baramati', 'Nashik'].map((loc) {
                            return ActionChip(label: Text(loc), onPressed: () => Navigator.of(ctx).pop());
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: ['Any Price', 'Under ₹100', '₹100 - ₹1000', 'Over ₹1000'].map((p) {
                            return ActionChip(label: Text(p), onPressed: () => Navigator.of(ctx).pop());
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Categories Horizontal Bar
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AgroColors.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? AgroColors.primaryDark : AgroColors.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Market Listings
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final t = item['type'];
                      if (t == 'waste') {
                        widget.onSelectWaste();
                      } else if (t == 'contract') {
                        widget.onSelectContracts();
                      } else if (t == 'product') {
                        widget.onSelectProducts();
                      } else {
                        widget.onSelectCrops();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 80,
                                height: 80,
                                color: AgroColors.primaryContainer,
                                child: const Icon(Icons.storefront, color: AgroColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AgroColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item['category'],
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AgroColors.primaryDark),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['title'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      item['price'],
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AgroColors.primary),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('•  Qty: ${item['qty']}', style: const TextStyle(fontSize: 13, color: AgroColors.textMuted)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: AgroColors.textLight),
                                    const SizedBox(width: 4),
                                    Text(item['location'], style: const TextStyle(fontSize: 12, color: AgroColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
