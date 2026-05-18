import 'package:flutter/material.dart';

class LuxuryExperienceSection extends StatelessWidget {
  const LuxuryExperienceSection({super.key});

  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;
  static const _subtext = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _charcoalLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _gold.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.spa_rounded, color: _gold, size: 20),
              SizedBox(width: 10),
              Text(
                'Arora Luxe Standard',
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExperienceRow(Icons.check_circle_outline_rounded, 'Premium high-end luxury products used exclusively.'),
          const SizedBox(height: 12),
          _buildExperienceRow(Icons.check_circle_outline_rounded, 'Conducted by certified and top-rated master stylists.'),
          const SizedBox(height: 12),
          _buildExperienceRow(Icons.check_circle_outline_rounded, 'Includes complimentary herbal tea/espresso.'),
        ],
      ),
    );
  }

  Widget _buildExperienceRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _gold, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _subtext,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
