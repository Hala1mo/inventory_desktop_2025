import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Product.dart';
import '../screens/Product/ProductDetails.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onPressed;

  const ProductCard({
    Key? key,
    required this.product,
    this.onPressed,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}
class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {


    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child:GestureDetector(
    onTap: widget.onPressed ?? () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProductDetails(product: widget.product);
        },
      );
    },
    child:Container(
        width: 200,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          color: Color(0xFF1A262D),
        ),
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: widget.product.imageUrl != null
                  ? widget.product.imageUrl!.startsWith('http')
                  ? Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
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
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              )
                  : Image.asset(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              )
                  : const Icon(
                Icons.image_not_supported,
                size: 30,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Content area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with discount badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style:  const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                         color:Colors.white
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // if (hasDiscount)
                    //   Text(
                    //     '($discountPercentage% Price Drop)',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.green[700],
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                  ],
                ),

                const SizedBox(height: 4),

                // Description
                if (widget.product.description != null &&
                    widget.product.description!.isNotEmpty)
                  Text(
                    widget.product.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 10),

                //  const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
      ),
    );
  }
}