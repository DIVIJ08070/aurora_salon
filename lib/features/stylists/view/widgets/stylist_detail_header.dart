import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/stylist_model.dart';

class StylistDetailHeader extends StatelessWidget {
  final StylistModel stylist;

  const StylistDetailHeader({
    super.key,
    required this.stylist,
  });

  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;

  @override
  Widget build(BuildContext context) {
    final cleanRole = stylist.specialisation.replaceAll('_', ' ').capitalizeFirst ?? '';
    final isActive = stylist.stylistStatus.toLowerCase() == 'active' || stylist.stylistStatus.toLowerCase() == 'available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _gold.withValues(alpha: 0.3), width: 1),
              ),
              child: Text(
                cleanRole.toUpperCase(),
                style: const TextStyle(
                  color: _gold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    stylist.stylistStatus.toUpperCase(),
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          stylist.name,
          style: const TextStyle(
            color: _text,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
