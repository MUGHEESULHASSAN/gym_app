
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/member_repository.dart';
import '../../../core/utils/date_utils.dart';

class MembersProvider extends ChangeNotifier {
  final MemberRepository _repo = MemberRepository();
  List<Member> _members = [];
  bool _loading = false;
  String _searchQuery = '';

  List<Member> get members {
    if (_searchQuery.isEmpty) return _members;
    return _members.where((m) => m.fullName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  bool get loading => _loading;

  Future<void> loadMembers() async {
    _loading = true;
    notifyListeners();
    try {
      _members = await _repo.fetchAll();
    } catch (e) {
      // handle
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  Future<void> addMember({required String fullName, required String phone, required String email, required String plan, required DateTime startDate, File? profile}) async {
    final expiry = addPlanToStartDate(startDate, plan);
    final member = Member(
      id: '',
      fullName: fullName,
      phone: phone,
      email: email,
      plan: plan,
      startDate: startDate,
      expiryDate: expiry,
      profileImageUrl: null,
      createdAt: DateTime.now(),
    );
    final saved = await _repo.add(member);
    if (profile != null) {
      final url = await _repo.uploadProfile(saved.id, profile);
      final withImage = saved.copyWith(profileImageUrl: url);
      await _repo.update(withImage);
    }
    await loadMembers();
  }

  Future<void> updateMember(Member member, {File? profile}) async {
    if (profile != null) {
      final url = await _repo.uploadProfile(member.id, profile);
      final updated = member.copyWith(profileImageUrl: url);
      await _repo.update(updated);
    } else {
      await _repo.update(member);
    }
    await loadMembers();
  }

  Future<void> deleteMember(String id) async {
    await _repo.delete(id);
    await loadMembers();
  }

  Future<void> checkIn(String memberId) async {
    await _repo.addAttendance(memberId, DateTime.now());
    notifyListeners();
  }

  Future<List<DateTime>> getAttendance(String memberId) async {
    return await _repo.fetchAttendance(memberId);
  }
}
