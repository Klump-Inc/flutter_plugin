import 'package:equatable/equatable.dart';

class Partner extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? logo;
  final bool isActive;
  final bool requiresPrequalification;
  final String? interest;
  final String? minLoanAmount;
  final String? maxLoanAmount;
  final int? minAge;
  final dynamic config;
  final dynamic createdAt;
  final DateTime? updatedAt;

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
      ];
}
