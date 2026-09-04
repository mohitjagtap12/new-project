import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/product.dart';
import '../../../widgets/primary_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final FarmProduct product;
  final Function(FarmProduct, int) onAddToCart;
  final Function(FarmProduct, int)? onBuyNow;
  final VoidCallback? onOpenCart;
  final int cartItemCount;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onAddToCart,
    this.onBuyNow,
    this.onOpenCart,
    this.cartItemCount = 0,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _addedToCartRecently = false;

  @override
  void initState() {
    super.initState();
    // Default quantity to 1 if in stock, else 0
    _quantity = widget.product.availableQuantity > 0 ? 1 : 0;
  }

  void _increment() {
    final maxStock = widget.product.availableQuantity;
    if (_quantity < maxStock) {
      setState(() => _quantity++);
    } else {
      AppUtils.showSnackBar(
        context,
        'Cannot add more: Only $maxStock ${widget.product.quantityUnit} available in stock.',
      );
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _handleAddToCart() {
    final p = widget.product;
    if (!p.isInStock || p.availableQuantity <= 0) {
      AppUtils.showSnackBar(context, 'This product is currently out of stock.');
      return;
    }
    if (_quantity <= 0) {
      AppUtils.showSnackBar(context, 'Please select at least 1 unit to add to cart.');
      return;
    }
    if (_quantity > p.availableQuantity) {
      AppUtils.showSnackBar(
        context,
        'Selected quantity exceeds available stock of ${p.availableQuantityText}.',
      );
      return;
    }

    widget.onAddToCart(p, _quantity);
    setState(() => _addedToCartRecently = true);

    AppUtils.showSnackBar(
      context,
      'Success! Added $_quantity x ${p.name} to your cart.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isOutOfStock = !p.isInStock || p.availableQuantity <= 0;
    final isLimited = p.isLimitedStock;

    final statusColor = isOutOfStock
        ? Colors.red.shade700
        : isLimited
            ? Colors.orange.shade800
            : AgroColors.primaryDark;

    final statusBg = isOutOfStock
        ? Colors.red.shade50
        : isLimited
            ? Colors.orange.shade50
            : AgroColors.primaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          if (widget.onOpenCart != null)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, size: 26),
                  onPressed: widget.onOpenCart,
                  tooltip: 'View Cart',
                ),
                if (widget.cartItemCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AgroColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        widget.cartItemCount > 99 ? '99+' : widget.cartItemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          if (isWide) {
            // Desktop/Tablet Two-Column Layout
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Image & Seller Card
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(p, height: 360),
                        const SizedBox(height: 20),
                        _buildSellerInfoCard(p),
                        if (p.features.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildFeaturesCard(p),
                        ],
                      ],
                    ),
                  ),
                ),
                // Divider
                Container(width: 1, color: AgroColors.border),
                // Right Column: Title, Specs, Quantity & Action Buttons
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndPriceSection(p, isOutOfStock, isLimited, statusColor, statusBg),
                        const SizedBox(height: 18),
                        _buildStockStatusCard(p, isOutOfStock, isLimited, statusColor, statusBg),
                        const SizedBox(height: 20),
                        _buildDescriptionSection(p),
                        if (p.specifications.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildSpecificationsCard(p),
                        ],
                        const SizedBox(height: 24),
                        _buildQuantitySelectorSection(p, isOutOfStock),
                        const SizedBox(height: 24),
                        _buildActionButtons(p, isOutOfStock),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Mobile Single-Column Scrollable Layout
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(p, height: 260),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleAndPriceSection(p, isOutOfStock, isLimited, statusColor, statusBg),
                      const SizedBox(height: 16),
                      _buildStockStatusCard(p, isOutOfStock, isLimited, statusColor, statusBg),
                      const SizedBox(height: 18),
                      _buildSellerInfoCard(p),
                      const SizedBox(height: 18),
                      _buildDescriptionSection(p),
                      if (p.specifications.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        _buildSpecificationsCard(p),
                      ],
                      if (p.features.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        _buildFeaturesCard(p),
                      ],
                      const SizedBox(height: 22),
                      _buildQuantitySelectorSection(p, isOutOfStock),
                      const SizedBox(height: 24),
                      _buildActionButtons(p, isOutOfStock),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- SUB-WIDGETS ---

  Widget _buildImageSection(FarmProduct p, {required double height}) {
    return Container(
      decoration: BoxDecoration(
        color: AgroColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: Image.network(
              p.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: height,
                color: AgroColors.primaryContainer,
                child: const Center(
                  child: Icon(Icons.inventory_2_outlined, size: 72, color: AgroColors.primary),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.72),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                p.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndPriceSection(
    FarmProduct p,
    bool isOutOfStock,
    bool isLimited,
    Color statusColor,
    Color statusBg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                p.name,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.textDark,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                p.status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Rating & Reviews
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 3),
                  Text(
                    p.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${p.reviewsCount} verified farmer reviews)',
              style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Price Line
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '₹${p.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AgroColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '/ ${p.priceUnit}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AgroColors.textMuted,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              '(Inclusive of GST)',
              style: TextStyle(fontSize: 11.5, color: AgroColors.textLight),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockStatusCard(
    FarmProduct p,
    bool isOutOfStock,
    bool isLimited,
    Color statusColor,
    Color statusBg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: statusBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            isOutOfStock
                ? Icons.cancel_outlined
                : isLimited
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
            size: 22,
            color: statusColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOutOfStock
                      ? 'Out of Stock'
                      : 'Available Stock: ${p.availableQuantityText}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Text(
                  isOutOfStock
                      ? 'Currently unavailable. Restocking soon.'
                      : isLimited
                          ? 'Hurry! Limited quantities left at store warehouse.'
                          : 'Ready for local delivery or farm pickup.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: statusColor.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfoCard(FarmProduct p) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AgroColors.primaryContainer,
            child: const Icon(Icons.storefront, color: AgroColors.primaryDark, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        p.sellerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AgroColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 16, color: AgroColors.primary),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AgroColors.textLight),
                    const SizedBox(width: 3),
                    Text(
                      p.sellerLocation,
                      style: const TextStyle(fontSize: 12.5, color: AgroColors.textMuted),
                    ),
                    const SizedBox(width: 10),
                    const Text('•', style: TextStyle(color: AgroColors.textLight)),
                    const SizedBox(width: 10),
                    const Text(
                      'Verified Seller',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AgroColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(FarmProduct p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Description',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AgroColors.textDark),
        ),
        const SizedBox(height: 6),
        Text(
          p.description,
          style: const TextStyle(fontSize: 13.5, color: AgroColors.textMuted, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSpecificationsCard(FarmProduct p) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AgroColors.surfaceVariant.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: const Row(
              children: [
                Icon(Icons.list_alt, size: 18, color: AgroColors.primary),
                SizedBox(width: 8),
                Text(
                  'Specifications',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: p.specifications.entries.length,
            separatorBuilder: (context, idx) => const Divider(height: 1, color: AgroColors.border),
            itemBuilder: (context, idx) {
              final entry = p.specifications.entries.elementAt(idx);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AgroColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AgroColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(FarmProduct p) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_outlined, size: 18, color: AgroColors.primary),
              SizedBox(width: 8),
              Text(
                'Key Highlights & Benefits',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AgroColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...p.features.map(
            (feat) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: AgroColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feat,
                      style: const TextStyle(fontSize: 13, color: AgroColors.textDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelectorSection(FarmProduct p, bool isOutOfStock) {
    final maxStock = p.availableQuantity;
    final isMaxReached = _quantity >= maxStock && maxStock > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AgroColors.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AgroColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Quantity:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AgroColors.textDark,
                ),
              ),
              if (!isOutOfStock)
                Text(
                  'Max $maxStock ${p.quantityUnit}',
                  style: const TextStyle(fontSize: 12, color: AgroColors.textMuted),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (isOutOfStock)
            const Text(
              'Cannot select quantity because this product is currently out of stock.',
              style: TextStyle(fontSize: 13, color: Colors.red),
            )
          else ...[
            Row(
              children: [
                // Stepper Controls
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AgroColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: _quantity > 1 ? _decrement : null,
                        tooltip: 'Decrease quantity',
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 40),
                        alignment: Alignment.center,
                        child: Text(
                          _quantity.toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AgroColors.textDark,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: _quantity < maxStock ? _increment : null,
                        tooltip: 'Increase quantity',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Units text and total calculation preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${p.quantityUnit} selected',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AgroColors.textDark,
                        ),
                      ),
                      Text(
                        'Item Total: ₹${(p.price * _quantity).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AgroColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isMaxReached) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Maximum available stock reached ($maxStock ${p.quantityUnit})',
                    style: const TextStyle(fontSize: 11.5, color: Colors.orange, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(FarmProduct p, bool isOutOfStock) {
    return Column(
      children: [
        Row(
          children: [
            // Add to Cart Button
            Expanded(
              child: PrimaryButton(
                label: _addedToCartRecently ? 'Add More to Cart' : 'Add to Cart',
                icon: Icons.add_shopping_cart,
                isOutlined: false,
                onPressed: isOutOfStock ? null : _handleAddToCart,
              ),
            ),
            if (widget.onBuyNow != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Buy Now',
                  icon: Icons.flash_on,
                  isOutlined: true,
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          _handleAddToCart();
                          widget.onBuyNow!(p, _quantity);
                        },
                ),
              ),
            ],
          ],
        ),
        if (_addedToCartRecently && widget.onOpenCart != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onOpenCart,
              icon: const Icon(Icons.shopping_cart_checkout, color: AgroColors.primary),
              label: const Text(
                'View Cart & Proceed',
                style: TextStyle(
                  color: AgroColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AgroColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
