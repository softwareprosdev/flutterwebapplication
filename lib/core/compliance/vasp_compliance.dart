import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum Jurisdiction {
  unitedStates,
  europeanUnion,
  unitedKingdom,
  canada,
  southKorea,
}

enum ComplianceLevel { basic, standard, enhanced }

class VASPComplianceService {
  static const String _storageKey = 'vasp_compliance_data';
  
  // Travel Rule thresholds (USD)
  static const double travelRuleThresholdUSA = 3000;
  static const double travelRuleThresholdEU = 1000;
  static const double travelRuleThresholdUK = 1000;
  static const double travelRuleThresholdCA = 3000;
  static const double travelRuleThresholdKR = 1000;

  static Future<VASPCredentials> registerVASP({
    required Jurisdiction jurisdiction,
    required String legalEntityName,
    required String registrationNumber,
    required String registeredAddress,
    required String website,
    required String contactEmail,
    required String complianceOfficerEmail,
  }) async {
    // In production: Submit to local regulator
    // USA: FinCEN MSB registration
    // EU: AMDL/DAMFB registration
    // UK: FCA registration
    // Canada: FINTRAC registration
    // Korea: Korea Financial Intelligence Unit

    final credentials = VASPCredentials(
      jurisdiction: jurisdiction,
      lei: _generateLEI(),
      vaspId: _generateVASPID(jurisdiction),
      legalEntityName: legalEntityName,
      registrationNumber: registrationNumber,
      registeredAddress: registeredAddress,
      website: website,
      contactEmail: contactEmail,
      complianceOfficerEmail: complianceOfficerEmail,
      registeredAt: DateTime.now(),
      status: VASPStatus.pendingApproval,
    );

    await _saveCredentials(credentials);
    return credentials;
  }

  static String _generateLEI() {
    final random = DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(20, '0');
    return '549300${random.substring(0, 20)}';
  }

  static String _generateVASPID(Jurisdiction jurisdiction) {
    final prefix = {
      Jurisdiction.unitedStates: 'US',
      Jurisdiction.europeanUnion: 'EU',
      Jurisdiction.unitedKingdom: 'GB',
      Jurisdiction.canada: 'CA',
      Jurisdiction.southKorea: 'KR',
    }[jurisdiction] ?? 'XX';
    
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    return '$prefix$VASP$timestamp';
  }

  static Future<void> _saveCredentials(VASPCredentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(credentials.toJson()));
  }

  static Future<VASPCredentials?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data == null) return null;
    return VASPCredentials.fromJson(jsonDecode(data));
  }

  static TravelRuleData prepareTravelRuleData({
    required String senderName,
    required String senderAddress,
    required String senderAccount,
    required String recipientName,
    required String recipientAddress,
    required String recipientAccount,
    required double amount,
    required String currency,
    required Jurisdiction jurisdiction,
  }) {
    final threshold = _getThreshold(jurisdiction);
    final isReportable = amount >= threshold;

    return TravelRuleData(
      senderName: senderName,
      senderAddress: senderAddress,
      senderAccount: senderAccount,
      recipientName: recipientName,
      recipientAddress: recipientAddress,
      recipientAccount: recipientAccount,
      amount: amount,
      currency: currency,
      isReportable: isReportable,
      threshold: threshold,
      timestamp: DateTime.now(),
    );
  }

  static double _getThreshold(Jurisdiction jurisdiction) {
    switch (jurisdiction) {
      case Jurisdiction.unitedStates:
        return travelRuleThresholdUSA;
      case Jurisdiction.europeanUnion:
        return travelRuleThresholdEU;
      case Jurisdiction.unitedKingdom:
        return travelRuleThresholdUK;
      case Jurisdiction.canada:
        return travelRuleThresholdCA;
      case Jurisdiction.southKorea:
        return travelRuleThresholdKR;
    }
  }

  static String getJurisdictionName(Jurisdiction jurisdiction) {
    switch (jurisdiction) {
      case Jurisdiction.unitedStates:
        return 'United States (FinCEN)';
      case Jurisdiction.europeanUnion:
        return 'European Union (AMLD5/6)';
      case Jurisdiction.unitedKingdom:
        return 'United Kingdom (FCA)';
      case Jurisdiction.canada:
        return 'Canada (FINTRAC)';
      case Jurisdiction.southKorea:
        return 'South Korea (PFSO)';
    }
  }

  static List<String> getRequiredFields(Jurisdiction jurisdiction) {
    switch (jurisdiction) {
      case Jurisdiction.unitedStates:
        return ['sender_name', 'sender_account', 'sender_address', 'recipient_name', 'recipient_account', 'amount', 'date'];
      case Jurisdiction.europeanUnion:
        return ['sender_name', 'sender_legal_person', 'sender_address', 'sender_country', 'recipient_name', 'recipient_legal_person', 'recipient_address', 'recipient_country', 'amount'];
      case Jurisdiction.unitedKingdom:
        return ['sender_name', 'sender_address', 'sender_account', 'recipient_name', 'recipient_address', 'recipient_account', 'amount'];
      case Jurisdiction.canada:
        return ['sender_name', 'sender_address', 'sender_account', 'recipient_name', 'recipient_address', 'recipient_account', 'amount'];
      case Jurisdiction.southKorea:
        return ['sender_name', 'sender_address', 'sender_account', 'recipient_name', 'recipient_address', 'recipient_account', 'amount', 'transaction_purpose'];
    }
  }

  static Future<KYCResult> performKYC({
    required String fullName,
    required DateTime dateOfBirth,
    required String nationality,
    required String address,
    required String idType,
    required String idNumber,
    required Jurisdiction jurisdiction,
  }) async {
    // In production: Integrate with KYC provider (Sumsub, Jumio, Onfido, etc.)
    
    // Simulate KYC verification
    await Future.delayed(const Duration(seconds: 2));

    return KYCResult(
      status: KYCStatus.approved,
      level: ComplianceLevel.enhanced,
      verifiedAt: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 365)),
      documentType: idType,
    );
  }

  static Future<SuspiciousActivityReport> submitSAR({
    required String transactionId,
    required String description,
    required String suspectedActivity,
    required List<String> involvedAddresses,
  }) async {
    // In production: Submit to appropriate financial intelligence unit
    
    return SuspiciousActivityReport(
      reportId: 'SAR${DateTime.now().millisecondsSinceEpoch}',
      transactionId: transactionId,
      description: description,
      suspectedActivity: suspectedActivity,
      involvedAddresses: involvedAddresses,
      submittedAt: DateTime.now(),
      status: SARStatus.submitted,
    );
  }

  static ComplianceChecklist getComplianceChecklist(Jurisdiction jurisdiction) {
    return ComplianceChecklist(
      jurisdiction: jurisdiction,
      requirements: [
        Requirement(name: 'VASP Registration', isRequired: true, description: getJurisdictionName(jurisdiction)),
        Requirement(name: 'KYC/AML Verification', isRequired: true, description: 'Customer due diligence'),
        Requirement(name: 'Travel Rule Compliance', isRequired: true, description: '>\$${_getThreshold(jurisdiction).toInt()}'),
        Requirement(name: 'Transaction Monitoring', isRequired: true, description: 'Ongoing monitoring'),
        Requirement(name: 'SAR Reporting', isRequired: true, description: 'Suspicious activity reports'),
        Requirement(name: 'Record Keeping', isRequired: true, description: '5-10 years retention'),
        Requirement(name: 'Capital Requirements', isRequired: false, description: 'Varies by jurisdiction'),
      ],
    );
  }
}

class VASPCredentials {
  final Jurisdiction jurisdiction;
  final String lei;
  final String vaspiId;
  final String legalEntityName;
  final String registrationNumber;
  final String registeredAddress;
  final String website;
  final String contactEmail;
  final String complianceOfficerEmail;
  final DateTime registeredAt;
  final VASPStatus status;

  VASPCredentials({
    required this.jurisdiction,
    required this.lei,
    required this.vaspiId,
    required this.legalEntityName,
    required this.registrationNumber,
    required this.registeredAddress,
    required this.website,
    required this.contactEmail,
    required this.complianceOfficerEmail,
    required this.registeredAt,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'jurisdiction': jurisdiction.index,
    'lei': lei,
    'vaspId': vaspiId,
    'legalEntityName': legalEntityName,
    'registrationNumber': registrationNumber,
    'registeredAddress': registeredAddress,
    'website': website,
    'contactEmail': contactEmail,
    'complianceOfficerEmail': complianceOfficerEmail,
    'registeredAt': registeredAt.toIso8601String(),
    'status': status.index,
  };

  factory VASPCredentials.fromJson(Map<String, dynamic> json) => VASPCredentials(
    jurisdiction: Jurisdiction.values[json['jurisdiction']],
    lei: json['lei'],
    vaspiId: json['vaspId'],
    legalEntityName: json['legalEntityName'],
    registrationNumber: json['registrationNumber'],
    registeredAddress: json['registeredAddress'],
    website: json['website'],
    contactEmail: json['contactEmail'],
    complianceOfficerEmail: json['complianceOfficerEmail'],
    registeredAt: DateTime.parse(json['registeredAt']),
    status: VASPStatus.values[json['status']],
  );
}

enum VASPStatus { pendingApproval, approved, suspended, revoked }

class TravelRuleData {
  final String senderName;
  final String senderAddress;
  final String senderAccount;
  final String recipientName;
  final String recipientAddress;
  final String recipientAccount;
  final double amount;
  final String currency;
  final bool isReportable;
  final double threshold;
  final DateTime timestamp;

  TravelRuleData({
    required this.senderName,
    required this.senderAddress,
    required this.senderAccount,
    required this.recipientName,
    required this.recipientAddress,
    required this.recipientAccount,
    required this.amount,
    required this.currency,
    required this.isReportable,
    required this.threshold,
    required this.timestamp,
  });
}

class KYCResult {
  final KYCStatus status;
  final ComplianceLevel level;
  final DateTime verifiedAt;
  final DateTime? expiryDate;
  final String? documentType;
  final String? rejectionReason;

  KYCResult({
    required this.status,
    required this.level,
    required this.verifiedAt,
    this.expiryDate,
    this.documentType,
    this.rejectionReason,
  });
}

enum KYCStatus { pending, approved, rejected, expired }

class SuspiciousActivityReport {
  final String reportId;
  final String transactionId;
  final String description;
  final String suspectedActivity;
  final List<String> involvedAddresses;
  final DateTime submittedAt;
  final SARStatus status;

  SuspiciousActivityReport({
    required this.reportId,
    required this.transactionId,
    required this.description,
    required this.suspectedActivity,
    required this.involvedAddresses,
    required this.submittedAt,
    required this.status,
  });
}

enum SARStatus { draft, submitted, underReview, closed }

class ComplianceChecklist {
  final Jurisdiction jurisdiction;
  final List<Requirement> requirements;

  ComplianceChecklist({
    required this.jurisdiction,
    required this.requirements,
  });
}

class Requirement {
  final String name;
  final bool isRequired;
  final String description;

  Requirement({
    required this.name,
    required this.isRequired,
    required this.description,
  });
}