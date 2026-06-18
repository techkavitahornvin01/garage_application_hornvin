import 'package:flutter/material.dart';
import 'package:hornvin/localization/app_localizations.dart';

class GarageProductCard extends StatelessWidget {
  final String name;
  final String price;
  final double rating;

  const GarageProductCard({
    super.key,
    required this.name,
    required this.price,
    this.rating = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5B31A).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.oil_barrel,
              color: Color(0xFFF5B31A),
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.trData(name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF5B31A), size: 14),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.trData(price),
            style: const TextStyle(
              color: Color(0xFFF5B31A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
