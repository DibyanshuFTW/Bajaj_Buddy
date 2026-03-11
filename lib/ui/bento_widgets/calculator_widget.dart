import 'package:flutter/material.dart';
import '../../models/insurance_calculator_model.dart';
import 'bento_card.dart';

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  double _years = 0;
  final double _basePremium = 15000;
  final double _ncbRate = 0.05; // 5% yearly discount as per standard NCB increment example

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final adjustedPremium = InsuranceCalculator.calculateAdjustedPremium(
      basePremium: _basePremium,
      ncbRate: _ncbRate,
      years: _years.toInt(),
    );

    return BentoCard(
      backgroundColor: const Color(0xFFE0F7FA), // Light Cyan
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, color: Color(0xFF00796B), size: 20),
              const SizedBox(width: 8),
              Text(
                'NCB Premium Calculator',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF004D40),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Claim-Free Years:',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                '${_years.toInt()}',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              activeTrackColor: Colors.black,
              inactiveTrackColor: Colors.black.withOpacity(0.05),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              value: _years,
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (val) {
                setState(() => _years = val);
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NCB Discount',
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.black54),
                  ),
                  Text(
                    '${(_years.toInt() * 5)}%',
                    style: const TextStyle(
                      color: Color(0xFF00796B),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Premium',
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.black54),
                  ),
                  Text(
                    '₹${adjustedPremium.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
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
