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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemImage(),
              const SizedBox(width: 12),
              Expanded(
                child: _buildItemDetails(),
              ),
              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.grey[200],
        child: widget.model!.thumbnailUrl != null && 
               widget.model!.thumbnailUrl!.isNotEmpty
            ? Image.network(
                widget.model!.thumbnailUrl!,
                width: 100,
                height: 100,
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
        const SizedBox(height: 8),
        if (widget.model!.info != null && widget.model!.info!.isNotEmpty)
          Text(
            widget.model!.info!,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuantityBadge(),
            const Spacer(),
            _buildPriceTag(),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
    final totalPrice = (widget.model!.price ?? 0) * (widget.quanNumber ?? 1);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[300]!, width: 1),
      ),
      child: Text(
        '\$${totalPrice.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      color: Colors.red[400],
      onPressed: () {
        // Add delete functionality here
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
        title: const Text('Remove Item'),
        content: Text('Remove ${widget.model!.title ?? 'this item'} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
    
              await removeItemFromCart(context, widget.model!.itemID!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}