import 'package:flutter/material.dart';

class StylistCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final String exp;
  final double rating;

  // Theme colors consistent with home
  static const _card = Color(0xFF2D2D2D);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;
  static const _subtext = Colors.white54;

  const StylistCard({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    required this.exp,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 35, backgroundImage: AssetImage(image)),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(role, style: const TextStyle(color: _subtext, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(exp, style: const TextStyle(color: _subtext, fontSize: 11)),
              Row(
                children: [
                  const Icon(Icons.star, color: _gold, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: _text,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
