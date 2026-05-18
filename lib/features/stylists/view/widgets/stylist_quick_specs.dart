import 'dart:ui';
import 'package:flutter/material.dart';
import '../../model/stylist_model.dart';

class StylistQuickSpecs extends StatelessWidget {
  final StylistModel stylist;

  const StylistQuickSpecs({
    super.key,
    required this.stylist,
  });

  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;

  @override
  Widget build(BuildContext context) {
    final cleanDays = stylist.workingDays.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    final startShift = stylist.shiftStart.substring(0, 5);
    final endShift = stylist.shiftEnd.substring(0, 5);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: _charcoalLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSpecItem(
                Icons.schedule_rounded,
                '$startShift - $endShift',
                'SHIFT HOURS',
              ),
              Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
              _buildSpecItem(
                Icons.calendar_month_rounded,
                cleanDays.split(',').length >= 5 ? 'Mon - Fri' : cleanDays,
                'WORK DAYS',
              ),
              Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
              _buildSpecItem(
                Icons.star_rounded,
                '4.9',
                'RATING',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: _gold, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: _text,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
