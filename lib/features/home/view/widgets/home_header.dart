import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String name;

  static const _gold = Color(0xFFC5A059);
  static const _subtext = Colors.white54;
  static const _card = Color(0xFF1C1C1C);

  const HomeHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $name',
                  style: const TextStyle(color: _subtext, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Good Morning!',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _card),
              child: const Icon(Icons.notifications_none, color: _gold),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: _gold, size: 20),
                    hintText: 'Search services...',
                    hintStyle: TextStyle(color: _subtext, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: _gold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Colors.black, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}
