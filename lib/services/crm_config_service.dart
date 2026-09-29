import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bfi_odisha/models/crm_config_model.dart';

class CRMConfigService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'crm_settings';
  static const String _configDocId = 'main_config';

  /// Fetch all CRM settings
  Future<CRMSettings?> getCRMSettings() async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(_configDocId).get();
      if (doc.exists) {
        return CRMSettings.fromJson(doc.data() ?? {});
      }
      return null;
    } catch (e) {
      print('Error fetching CRM settings: $e');
      return null;
    }
  }

  /// Fetch all product categories
  Future<List<ProductCategory>> getProductCategories() async {
    try {
      final settings = await getCRMSettings();
      return settings?.productCategories ?? [];
    } catch (e) {
      print('Error fetching product categories: $e');
      return [];
    }
  }

  /// Fetch all commission structures
  Future<List<CommissionStructure>> getCommissionStructures() async {
    try {
      final settings = await getCRMSettings();
      return settings?.commissionStructures ?? [];
    } catch (e) {
      print('Error fetching commission structures: $e');
      return [];
    }
  }

  /// Fetch all lead sources
  Future<List<LeadSource>> getLeadSources() async {
    try {
      final settings = await getCRMSettings();
      return settings?.leadSources ?? [];
    } catch (e) {
      print('Error fetching lead sources: $e');
      return [];
    }
  }

  /// Fetch all lead statuses
  Future<List<LeadStatus>> getLeadStatuses() async {
    try {
      final settings = await getCRMSettings();
      return settings?.leadStatuses ?? [];
    } catch (e) {
      print('Error fetching lead statuses: $e');
      return [];
    }
  }

  /// Get commission structure for a specific product category
  Future<CommissionStructure?> getCommissionStructureForProduct(String productCategoryId) async {
    try {
      final structures = await getCommissionStructures();
      return structures.firstWhere(
        (s) => s.productCategoryId == productCategoryId && s.isActive,
        orElse: () => CommissionStructure(
          id: '',
          productCategoryId: '',
          partnerSharePercentage: 70.0,
          tdsPercentage: 2.0,
          description: '',
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      print('Error fetching commission structure: $e');
      return null;
    }
  }

  /// Add a new product category
  Future<void> addProductCategory(ProductCategory category) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.productCategories.add(category);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error adding product category: $e');
    }
  }

  /// Update an existing product category
  Future<void> updateProductCategory(String categoryId, ProductCategory updatedCategory) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        final index = settings.productCategories.indexWhere((p) => p.id == categoryId);
        if (index != -1) {
          settings.productCategories[index] = updatedCategory;
          await _updateCRMSettings(settings);
        }
      }
    } catch (e) {
      print('Error updating product category: $e');
    }
  }

  /// Delete a product category
  Future<void> deleteProductCategory(String categoryId) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.productCategories.removeWhere((p) => p.id == categoryId);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error deleting product category: $e');
    }
  }

  /// Add a new commission structure
  Future<void> addCommissionStructure(CommissionStructure structure) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.commissionStructures.add(structure);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error adding commission structure: $e');
    }
  }

  /// Update an existing commission structure
  Future<void> updateCommissionStructure(String structureId, CommissionStructure updatedStructure) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        final index = settings.commissionStructures.indexWhere((c) => c.id == structureId);
        if (index != -1) {
          settings.commissionStructures[index] = updatedStructure;
          await _updateCRMSettings(settings);
        }
      }
    } catch (e) {
      print('Error updating commission structure: $e');
    }
  }

  /// Delete a commission structure
  Future<void> deleteCommissionStructure(String structureId) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.commissionStructures.removeWhere((c) => c.id == structureId);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error deleting commission structure: $e');
    }
  }

  /// Add a new lead source
  Future<void> addLeadSource(LeadSource source) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.leadSources.add(source);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error adding lead source: $e');
    }
  }

  /// Update an existing lead source
  Future<void> updateLeadSource(String sourceId, LeadSource updatedSource) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        final index = settings.leadSources.indexWhere((s) => s.id == sourceId);
        if (index != -1) {
          settings.leadSources[index] = updatedSource;
          await _updateCRMSettings(settings);
        }
      }
    } catch (e) {
      print('Error updating lead source: $e');
    }
  }

  /// Delete a lead source
  Future<void> deleteLeadSource(String sourceId) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.leadSources.removeWhere((s) => s.id == sourceId);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error deleting lead source: $e');
    }
  }

  /// Add a new lead status
  Future<void> addLeadStatus(LeadStatus status) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.leadStatuses.add(status);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error adding lead status: $e');
    }
  }

  /// Update an existing lead status
  Future<void> updateLeadStatus(String statusId, LeadStatus updatedStatus) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        final index = settings.leadStatuses.indexWhere((s) => s.id == statusId);
        if (index != -1) {
          settings.leadStatuses[index] = updatedStatus;
          await _updateCRMSettings(settings);
        }
      }
    } catch (e) {
      print('Error updating lead status: $e');
    }
  }

  /// Delete a lead status
  Future<void> deleteLeadStatus(String statusId) async {
    try {
      final settings = await getCRMSettings();
      if (settings != null) {
        settings.leadStatuses.removeWhere((s) => s.id == statusId);
        await _updateCRMSettings(settings);
      }
    } catch (e) {
      print('Error deleting lead status: $e');
    }
  }

  /// Internal method to update the entire CRM settings document
  Future<void> _updateCRMSettings(CRMSettings settings) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(_configDocId)
          .set(settings.toJson(), SetOptions(merge: false));
    } catch (e) {
      print('Error updating CRM settings: $e');
    }
  }

  /// Initialize default CRM settings (call once during app setup)
  Future<void> initializeDefaultSettings() async {
    try {
      final existing = await getCRMSettings();
      if (existing != null) {
        return; // Already initialized
      }

      final defaultSettings = CRMSettings(
        id: _configDocId,
        productCategories: [
          ProductCategory(
            id: 'loan_personal',
            name: 'Personal Loan',
            type: 'Loan',
            baseCommissionRate: 2.0,
            description: 'Personal loan products',
            isActive: true,
            createdAt: DateTime.now(),
          ),
          ProductCategory(
            id: 'loan_business',
            name: 'Business Loan',
            type: 'Loan',
            baseCommissionRate: 2.5,
            description: 'Business loan products',
            isActive: true,
            createdAt: DateTime.now(),
          ),
          ProductCategory(
            id: 'loan_cv',
            name: 'Commercial Vehicle Loan',
            type: 'Loan',
            baseCommissionRate: 1.8,
            description: 'CV loan products',
            isActive: true,
            createdAt: DateTime.now(),
          ),
        ],
        commissionStructures: [
          CommissionStructure(
            id: 'comm_personal',
            productCategoryId: 'loan_personal',
            partnerSharePercentage: 70.0,
            tdsPercentage: 2.0,
            minCommission: 500.0,
            maxCommission: double.infinity,
            description: 'Personal loan commission split',
            isActive: true,
            createdAt: DateTime.now(),
          ),
          CommissionStructure(
            id: 'comm_business',
            productCategoryId: 'loan_business',
            partnerSharePercentage: 70.0,
            tdsPercentage: 2.0,
            minCommission: 500.0,
            maxCommission: double.infinity,
            description: 'Business loan commission split',
            isActive: true,
            createdAt: DateTime.now(),
          ),
        ],
        leadSources: [
          LeadSource(
            id: 'source_direct',
            name: 'Direct',
            description: 'Direct customer acquisition',
            isActive: true,
            createdAt: DateTime.now(),
          ),
          LeadSource(
            id: 'source_referral',
            name: 'Referral',
            description: 'Customer referral',
            isActive: true,
            createdAt: DateTime.now(),
          ),
        ],
        leadStatuses: [
          LeadStatus(
            id: 'status_new',
            name: 'New',
            color: '#2196F3',
            order: 1,
            isFinalStatus: false,
            createdAt: DateTime.now(),
          ),
          LeadStatus(
            id: 'status_submitted',
            name: 'Submitted to Bank',
            color: '#FF9800',
            order: 2,
            isFinalStatus: false,
            createdAt: DateTime.now(),
          ),
          LeadStatus(
            id: 'status_approved',
            name: 'Approved',
            color: '#4CAF50',
            order: 3,
            isFinalStatus: false,
            createdAt: DateTime.now(),
          ),
          LeadStatus(
            id: 'status_disbursed',
            name: 'Disbursed',
            color: '#8BC34A',
            order: 4,
            isFinalStatus: true,
            createdAt: DateTime.now(),
          ),
        ],
        lastUpdated: DateTime.now(),
      );

      await _updateCRMSettings(defaultSettings);
      print('Default CRM settings initialized successfully');
    } catch (e) {
      print('Error initializing default settings: $e');
    }
  }
}
