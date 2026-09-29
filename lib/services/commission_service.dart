import 'package:bfi_odisha/services/crm_config_service.dart';

class DynamicCommissionEngine {
  final CRMConfigService _crmService;

  DynamicCommissionEngine(this._crmService);

  /// Calculate commission using dynamic CRM settings
  Future<Map<String, double>> calculateDynamicPayout({
    required double netDisbursedAmount,
    required String productCategoryId,
  }) async {
    try {
      final commissionStructure = await _crmService.getCommissionStructureForProduct(productCategoryId);
      if (commissionStructure == null || commissionStructure.id.isEmpty) {
        throw Exception('Commission structure not found for product: $productCategoryId');
      }

      final categories = await _crmService.getProductCategories();
      final productCategory = categories.firstWhere(
        (cat) => cat.id == productCategoryId,
        orElse: () => throw Exception('Product category not found: $productCategoryId'),
      );

      final totalBankPayoutRate = productCategory.baseCommissionRate;
      final grossBankPayout = netDisbursedAmount * (totalBankPayoutRate / 100);
      final partnerGross = grossBankPayout * (commissionStructure.partnerSharePercentage / 100);
      final bfiOdishaShare = grossBankPayout - partnerGross;
      final tdsAmount = partnerGross * (commissionStructure.tdsPercentage / 100);
      var partnerNetPayout = partnerGross - tdsAmount;

      if (partnerNetPayout < commissionStructure.minCommission) {
        partnerNetPayout = commissionStructure.minCommission;
      } else if (partnerNetPayout > commissionStructure.maxCommission) {
        partnerNetPayout = commissionStructure.maxCommission;
      }

      return {
        'netDisbursed': netDisbursedAmount,
        'baseCommissionRate': totalBankPayoutRate,
        'grossBankPayout': grossBankPayout,
        'partnerSharePercentage': commissionStructure.partnerSharePercentage,
        'bfiOdishaShare': bfiOdishaShare,
        'partnerGross': partnerGross,
        'tdsPercentage': commissionStructure.tdsPercentage,
        'tdsAmount': tdsAmount,
        'partnerNetPayout': partnerNetPayout,
        'minCommission': commissionStructure.minCommission,
        'maxCommission': commissionStructure.maxCommission,
      };
    } catch (e) {
      print('Error calculating dynamic payout: $e');
      return {};
    }
  }

  /// Calculate commission for multiple leads.
  Future<List<Map<String, dynamic>>> calculateBatchPayouts({
    required List<Map<String, dynamic>> leads,
  }) async {
    final results = <Map<String, dynamic>>[];
    for (final lead in leads) {
      final payout = await calculateDynamicPayout(
        netDisbursedAmount: (lead['netAmount'] as num?)?.toDouble() ?? 0.0,
        productCategoryId: lead['productCategoryId'] as String? ?? '',
      );
      results.add({
        'leadId': lead['leadId'],
        'productCategoryId': lead['productCategoryId'],
        'payout': payout,
      });
    }
    return results;
  }

  /// Get formatted payout breakdown for UI display.
  Future<String> getFormattedPayoutBreakdown({
    required double netDisbursedAmount,
    required String productCategoryId,
  }) async {
    final payout = await calculateDynamicPayout(
      netDisbursedAmount: netDisbursedAmount,
      productCategoryId: productCategoryId,
    );
    if (payout.isEmpty) return 'Unable to calculate payout';

    final buffer = StringBuffer()
      ..writeln('Commission Breakdown')
      ..writeln('Disbursed Amount: ₹${payout['netDisbursed']?.toStringAsFixed(2)}')
      ..writeln('Bank Payout Rate: ${payout['baseCommissionRate']?.toStringAsFixed(2)}%')
      ..writeln('Gross Bank Payout: ₹${payout['grossBankPayout']?.toStringAsFixed(2)}')
      ..writeln('Partner Share: ${payout['partnerSharePercentage']?.toStringAsFixed(1)}%')
      ..writeln('Partner Gross: ₹${payout['partnerGross']?.toStringAsFixed(2)}')
      ..writeln('TDS (${payout['tdsPercentage']?.toStringAsFixed(1)}%): ₹${payout['tdsAmount']?.toStringAsFixed(2)}')
      ..writeln('Partner Net: ₹${payout['partnerNetPayout']?.toStringAsFixed(2)}')
      ..writeln('BFi Odisha Share: ₹${payout['bfiOdishaShare']?.toStringAsFixed(2)}');
    return buffer.toString();
  }
}

/// Legacy static commission engine kept for backward compatibility.
class CommissionEngine {
  static double getProductBaseRate(String category) {
    switch (category) {
      case 'Personal Loan': return 2.0;
      case 'Business Loan': return 2.5;
      case 'Commercial Vehicle & Equipment': return 1.8;
      case 'Used Vehicle Loan': return 2.2;
      case 'New Car Loan': return 1.5;
      default: return 1.5;
    }
  }

  static Map<String, double> calculatePayout({
    required double netDisbursedAmount,
    required String productCategory,
    double partnerSharePercentage = 70.0,
  }) {
    final totalBankPayoutRate = getProductBaseRate(productCategory);
    final grossBankPayout = netDisbursedAmount * (totalBankPayoutRate / 100);
    final partnerGross = grossBankPayout * (partnerSharePercentage / 100);
    final bfiOdishaShare = grossBankPayout - partnerGross;
    final tdsAmount = partnerGross * 0.02;
    final partnerNetPayout = partnerGross - tdsAmount;

    return {
      'netDisbursed': netDisbursedAmount,
      'grossBankPayout': grossBankPayout,
      'bfiOdishaShare': bfiOdishaShare,
      'partnerGross': partnerGross,
      'tdsDeduction': tdsAmount,
      'partnerNetPayout': partnerNetPayout,
    };
  }
}
