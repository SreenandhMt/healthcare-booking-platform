import 'package:healthcare_booking_platform/features/home/models/treatment_model.dart';

class PatientDetailModel {
  final int id;
  final int treatment;
  final String treatmentName;
  final String male;
  final String female;
  final int patient;

  PatientDetailModel({
    required this.id,
    required this.treatment,
    required this.treatmentName,
    required this.male,
    required this.female,
    required this.patient,
  });

  factory PatientDetailModel.fromJson(Map<String, dynamic> json) {
    return PatientDetailModel(
      id: json['id'] ?? 0,
      treatment: json['treatment'] ?? 0,
      treatmentName: json['treatment_name'] ?? '',
      male: json['male']?.toString() ?? '0',
      female: json['female']?.toString() ?? '0',
      patient: json['patient'] ?? 0,
    );
  }
}

class PatientModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String user;
  final String payment;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateNdTime;
  final BranchModel? branch;
  final List<PatientDetailModel> patientDetailsSet;
  final bool isActive;
  final int? index;

  PatientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.user,
    required this.payment,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    this.branch,
    required this.patientDetailsSet,
    required this.isActive,
    this.index,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json, [int? index]) {
    return PatientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      user: json['user']?.toString() ?? '',
      payment: json['payment'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      advanceAmount: (json['advance_amount'] as num?)?.toDouble() ?? 0.0,
      balanceAmount: (json['balance_amount'] as num?)?.toDouble() ?? 0.0,
      dateNdTime: json['date_nd_time'] ?? '',
      branch: json['branch'] != null
          ? BranchModel.fromJson(json['branch'])
          : null,
      patientDetailsSet:
          (json['patientdetails_set'] as List?)
              ?.map((e) => PatientDetailModel.fromJson(e))
              .toList() ??
          [],
      isActive: json['is_active'] ?? false,
      index: index,
    );
  }

  PatientModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? user,
    String? payment,
    double? totalAmount,
    double? discountAmount,
    double? advanceAmount,
    double? balanceAmount,
    String? dateNdTime,
    BranchModel? branch,
    List<PatientDetailModel>? patientDetailsSet,
    bool? isActive,
    int? index,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      user: user ?? this.user,
      payment: payment ?? this.payment,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      dateNdTime: dateNdTime ?? this.dateNdTime,
      branch: branch ?? this.branch,
      patientDetailsSet: patientDetailsSet ?? this.patientDetailsSet,
      isActive: isActive ?? this.isActive,
      index: index ?? this.index,
    );
  }
}
