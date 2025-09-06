
import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String plan;
  final DateTime startDate;
  final DateTime expiryDate;
  final String? profileImageUrl;
  final DateTime createdAt;

  Member({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.plan,
    required this.startDate,
    required this.expiryDate,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory Member.fromMap(String id, Map<String, dynamic> map) {
    return Member(
      id: id,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      plan: map['plan'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      expiryDate: (map['expiryDate'] as Timestamp).toDate(),
      profileImageUrl: map['profileImageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'plan': plan,
      'startDate': Timestamp.fromDate(startDate),
      'expiryDate': Timestamp.fromDate(expiryDate),
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Member copyWith({String? fullName, String? phone, String? email, String? plan, DateTime? startDate, DateTime? expiryDate, String? profileImageUrl}) {
    return Member(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
    );
  }
}
