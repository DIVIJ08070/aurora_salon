import 'dart:ui';
import 'package:flutter/material.dart';
import '../../model/stylist_model.dart';

class StylistBottomBar extends StatelessWidget {
  final StylistModel stylist;
  final VoidCallback onBookingPressed;

  const StylistBottomBar({
    super.key,
    required this.stylist,
    required this.onBookingPressed,
  });

  static const _bg = Color(0xFF0D0D0D);
  static const _gold = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: _bg.withValues(alpha: 0.85),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBookingPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                  shadowColor: _gold.withValues(alpha: 0.4),
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'BOOK APPOINTMENT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
