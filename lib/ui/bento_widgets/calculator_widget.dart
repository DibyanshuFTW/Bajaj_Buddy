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
      backgroundColor: isDark ? const Color(0xFF1A2A2A) : const Color(0xFFE0F7FA), // Light Cyan
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, color: Color(0xFF00796B), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'NCB Premium Calculator',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF004D40),
                  ),
                  overflow: TextOverflow.ellipsis,
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
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : null),
              ),
              Text(
                '${_years.toInt()}',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : null),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              activeTrackColor: isDark ? Colors.white : Colors.black,
              inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
              thumbColor: isDark ? const Color(0xFF80CBC4) : Colors.white,
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
                    style: theme.textTheme.labelSmall?.copyWith(color: isDark ? Colors.white54 : Colors.black54),
                  ),
                  Text(
                    '${(_years.toInt() * 5)}%',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF00796B),
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
                    style: theme.textTheme.labelSmall?.copyWith(color: isDark ? Colors.white54 : Colors.black54),
                  ),
                  Text(
                    '₹${adjustedPremium.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
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
