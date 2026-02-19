import 'package:flutter/material.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  final BuildContext? context;
  final int? quanNumber;

  const CartItemDesign({
    super.key,
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
Widget build(BuildContext context) {
  if (widget.model == null) return const SizedBox.shrink();

  return Card(
    color: Colors.grey[100],
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row( 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildItemImage(),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildItemDetails()),
                    _buildDeleteButton(),
                  ],
                ),
                
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildQuantityBadge(),
                    const SizedBox(width: 8),
                    _buildPriceTag(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildItemImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 120,
            height: 120,
            color: Colors.grey[200],
            child: widget.model!.imageUrl != null && 
                   widget.model!.imageUrl!.isNotEmpty
                ? Image.network(
                    widget.model!.imageUrl!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  )
                : const Icon(
                    Icons.restaurant,
                    size: 50,
                    color: Colors.grey,
                  ),
          ),
        ),
        
        // Discount badge on image
        if (widget.model!.hasDiscount)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${widget.model!.discount!.toInt()}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.model!.title ?? 'Item',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        
        // Tags
        if (widget.model!.tags != null && widget.model!.tags!.isNotEmpty)
          Wrap(
            spacing: 4,
            children: widget.model!.tags!.take(2).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_offer, color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        
        const SizedBox(height: 8),
        
        if (widget.model!.info != null && widget.model!.info!.isNotEmpty)
          Text(
            widget.model!.info!,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),  
      ],
    );
  }

  Widget _buildQuantityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.clear, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            '${widget.quanNumber ?? 1}',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTag() {
    final quantity = widget.quanNumber ?? 1;
    final pricePerItem = widget.model!.hasDiscount 
        ? widget.model!.discountedPrice 
        : (widget.model!.price ?? 0);
    final totalPrice = pricePerItem * quantity;
    final originalTotal = (widget.model!.price ?? 0) * quantity;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.model!.hasDiscount)
          Text(
            '₹${originalTotal.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              decoration: TextDecoration.lineThrough,
            ),
          ),
        
        // Final price
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.model!.hasDiscount 
                ? Colors.red.shade50 
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.model!.hasDiscount 
                  ? Colors.red.shade300 
                  : Colors.green.shade300,
              width: 1,
            ),
          ),
          child: Text(
            '₹${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.model!.hasDiscount 
                  ? Colors.red.shade700 
                  : Colors.green.shade700,
            ),
          ),
        ),
        
        // Savings badge
        if (widget.model!.hasDiscount)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Save ₹${(originalTotal - totalPrice).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete_forever),
      color: Colors.redAccent,
      iconSize: 28,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
      onPressed: () {
        _showDeleteConfirmation();
      },
    );
  }

  void _showDeleteConfirmation() {
    if (widget.model?.itemID == null) {
      Fluttertoast.showToast(msg: "Cannot remove item: Invalid item ID");
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        elevation: 4,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.delete_outline, color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Remove Item',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Are you sure you want to remove ${widget.model!.title ?? 'this item'} from your cart?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 40,),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await removeItemFromCart(context, widget.model!.itemID!);
                              Fluttertoast.showToast(msg: "Item removed from cart");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}