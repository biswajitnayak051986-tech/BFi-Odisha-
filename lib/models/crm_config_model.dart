class ProductCategory {
  final String id;
  final String name;
  final String type; // 'Loan' or 'Insurance'
  final double baseCommissionRate; // percentage
  final String description;
  final bool isActive;
  final DateTime createdAt;

  ProductCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.baseCommissionRate,
    required this.description,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'baseCommissionRate': baseCommissionRate,
    'description': description,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    type: json['type'] ?? 'Loan',
    baseCommissionRate: (json['baseCommissionRate'] ?? 0.0).toDouble(),
    description: json['description'] ?? '',
    isActive: json['isActive'] ?? true,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class CommissionStructure {
  final String id;
  final String productCategoryId;
  final double partnerSharePercentage; // e.g., 70% to partner, 30% to BFi
  final double tdsPercentage; // Tax deduction percentage (e.g., 2%)
  final double minCommission;
  final double maxCommission;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  CommissionStructure({
    required this.id,
    required this.productCategoryId,
    required this.partnerSharePercentage,
    required this.tdsPercentage,
    this.minCommission = 0.0,
    this.maxCommission = double.infinity,
    required this.description,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'productCategoryId': productCategoryId,
    'partnerSharePercentage': partnerSharePercentage,
    'tdsPercentage': tdsPercentage,
    'minCommission': minCommission,
    'maxCommission': maxCommission,
    'description': description,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CommissionStructure.fromJson(Map<String, dynamic> json) => CommissionStructure(
    id: json['id'] ?? '',
    productCategoryId: json['productCategoryId'] ?? '',
    partnerSharePercentage: (json['partnerSharePercentage'] ?? 70.0).toDouble(),
    tdsPercentage: (json['tdsPercentage'] ?? 2.0).toDouble(),
    minCommission: (json['minCommission'] ?? 0.0).toDouble(),
    maxCommission: (json['maxCommission'] ?? double.infinity).toDouble(),
    description: json['description'] ?? '',
    isActive: json['isActive'] ?? true,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class LeadSource {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  LeadSource({
    required this.id,
    required this.name,
    required this.description,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };

  factory LeadSource.fromJson(Map<String, dynamic> json) => LeadSource(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    isActive: json['isActive'] ?? true,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class LeadStatus {
  final String id;
  final String name;
  final String color; // hex color code
  final int order; // sequence in pipeline
  final bool isFinalStatus;
  final DateTime createdAt;

  LeadStatus({
    required this.id,
    required this.name,
    required this.color,
    required this.order,
    this.isFinalStatus = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'order': order,
    'isFinalStatus': isFinalStatus,
    'createdAt': createdAt.toIso8601String(),
  };

  factory LeadStatus.fromJson(Map<String, dynamic> json) => LeadStatus(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    color: json['color'] ?? '#808080',
    order: json['order'] ?? 0,
    isFinalStatus: json['isFinalStatus'] ?? false,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class CRMSettings {
  final String id;
  final List<ProductCategory> productCategories;
  final List<CommissionStructure> commissionStructures;
  final List<LeadSource> leadSources;
  final List<LeadStatus> leadStatuses;
  final DateTime lastUpdated;

  CRMSettings({
    required this.id,
    required this.productCategories,
    required this.commissionStructures,
    required this.leadSources,
    required this.leadStatuses,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'productCategories': productCategories.map((p) => p.toJson()).toList(),
    'commissionStructures': commissionStructures.map((c) => c.toJson()).toList(),
    'leadSources': leadSources.map((s) => s.toJson()).toList(),
    'leadStatuses': leadStatuses.map((s) => s.toJson()).toList(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory CRMSettings.fromJson(Map<String, dynamic> json) => CRMSettings(
    id: json['id'] ?? '',
    productCategories: (json['productCategories'] as List<dynamic>?)
        ?.map((p) => ProductCategory.fromJson(p as Map<String, dynamic>))
        .toList() ?? [],
    commissionStructures: (json['commissionStructures'] as List<dynamic>?)
        ?.map((c) => CommissionStructure.fromJson(c as Map<String, dynamic>))
        .toList() ?? [],
    leadSources: (json['leadSources'] as List<dynamic>?)
        ?.map((s) => LeadSource.fromJson(s as Map<String, dynamic>))
        .toList() ?? [],
    leadStatuses: (json['leadStatuses'] as List<dynamic>?)
        ?.map((s) => LeadStatus.fromJson(s as Map<String, dynamic>))
        .toList() ?? [],
    lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : DateTime.now(),
  );
}
