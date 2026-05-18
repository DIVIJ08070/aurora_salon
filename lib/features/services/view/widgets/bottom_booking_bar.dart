import 'dart:ui';
import 'package:flutter/material.dart';
import '../../model/service_model.dart';

class BottomBookingBar extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onBookingPressed;

  const BottomBookingBar({
    super.key,
    required this.service,
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'TOTAL PRICE',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${service.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
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
                      'RESERVE NOW',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
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
