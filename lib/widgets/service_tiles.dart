import 'package:flutter/material.dart';
import 'package:trendz_customer/theming/app_colors.dart';

class ModernServiceTile extends StatelessWidget {
  final String serviceName;
  final String price;
  final String imageurl;

  const ModernServiceTile({
    super.key,
    required this.serviceName,
    required this.price,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Image with circular border
          Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondaryGold,
                width: 2,
              ),
              image: DecorationImage(
                image: AssetImage(imageurl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Service name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              serviceName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Price
          Text(
            "LKR $price",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryGold,
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}