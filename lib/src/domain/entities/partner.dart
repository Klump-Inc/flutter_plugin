import 'package:equatable/equatable.dart';
import 'package:klump_checkout/src/src.dart';

class Partner extends Equatable {
  final String? id;
  final String name;
  final String slug;
  final String? logo;
  final bool? isActive;
  final bool? requiresPrequalification;
  final String? interest;
  final String? minLoanAmount;
  final String? maxLoanAmount;
  final int? minAge;
  final dynamic config;
  final dynamic createdAt;
  final DateTime? updatedAt;
  final NextStep? nextStep;
  final bool? isActiveForMobile;
  final PartnerMetadataModel? metadata;
  final List<dynamic>? keywords;
  final bool? isAvailable;

  const Partner({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    required this.isActive,
    required this.requiresPrequalification,
    this.interest,
    this.minLoanAmount,
    this.maxLoanAmount,
    this.minAge,
    required this.config,
    this.createdAt,
    this.updatedAt,
    this.nextStep,
    this.isActiveForMobile,
    this.metadata,
    this.keywords,
    this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        logo,
        isActive,
        requiresPrequalification,
        interest,
        minLoanAmount,
        maxLoanAmount,
        minAge,
        config,
        createdAt,
        updatedAt,
        nextStep,
        isActiveForMobile,
        metadata,
        keywords,
        isAvailable,
      ];
}

extension PartnerLenderSearchX on Partner {
  /// Whether [lowerQuery] matches [name], the selected [partnerName] field, or any [keywords] entry.
  bool matchesLenderSearchQuery(String lowerQuery, String partnerName) {
    if (name.toLowerCase().contains(lowerQuery) ||
        partnerName.toLowerCase() == lowerQuery) {
      return true;
    }
    final kws = keywords;
    if (kws == null || kws.isEmpty) return false;
    for (final s in kws) {
      if (s.toString().isNotEmpty &&
          s.toString().toLowerCase().contains(lowerQuery)) {
        return true;
      }
    }
    return false;
  }
}
