import 'dart:math';

class InsuranceCalculator {
  // P_adj = P_base * (1 - r_ncb)^t
  static double calculateAdjustedPremium({
    required double basePremium,
    required double ncbRate,
    required int years,
  }) {
    if (years <= 0) return basePremium;
    return basePremium * pow(1 - ncbRate, years);
  }
}
