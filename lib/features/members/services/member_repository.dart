
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/member.dart';

class MemberRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  MemberRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference get membersRef => _firestore.collection('members');

  Future<List<Member>> fetchAll() async {
    final snap = await membersRef.orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => Member.fromMap(d.id, d.data()! as Map<String,dynamic>)).toList();
  }

  Future<Member> add(Member member) async {
    final doc = membersRef.doc();
    final data = member.copyWith().toMap();
    await doc.set(data);
    final saved = await doc.get();
    return Member.fromMap(saved.id, saved.data()! as Map<String,dynamic>);
  }

  Future<void> update(Member member) async {
    await membersRef.doc(member.id).update(member.toMap());
  }

  Future<void> delete(String id) async {
    await membersRef.doc(id).delete();
  }

  Future<void> addAttendance(String memberId, DateTime date) async {
    await membersRef.doc(memberId).collection('attendance').add({'date': Timestamp.fromDate(date)});
  }

  Future<List<DateTime>> fetchAttendance(String memberId) async {
    final snap = await membersRef.doc(memberId).collection('attendance').orderBy('date', descending: true).get();
    return snap.docs.map((d) => (d.data()['date'] as Timestamp).toDate()).toList();
  }

  Future<String?> uploadProfile(String memberId, File file) async {
    final ref = _storage.ref().child('profiles/$memberId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }
}
