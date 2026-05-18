import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/service_model.dart';

class ServiceQuickSpecs extends StatelessWidget {
  final ServiceModel service;

  const ServiceQuickSpecs({
    super.key,
    required this.service,
  });

  static const _charcoalLight = Color(0xFF1C1C1C);
  static const _gold = Color(0xFFC5A059);
  static const _text = Colors.white;

  @override
  Widget build(BuildContext context) {
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
                '${service.durationMinutes} Mins',
                'DURATION',
              ),
              Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
              _buildSpecItem(
                Icons.wc_rounded,
                service.gender.isEmpty ? 'Unisex' : service.gender.capitalizeFirst!,
                'GENDER',
              ),
              Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
              _buildSpecItem(
                Icons.payments_outlined,
                '₹${service.price.toStringAsFixed(0)}',
                'PRICE',
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
            fontSize: 14,
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
