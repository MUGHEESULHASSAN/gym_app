
import 'package:flutter/material.dart';
import '../../features/members/models/member.dart';
import 'package:intl/intl.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const MemberCard({super.key, required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final expired = member.expiryDate.isBefore(DateTime.now());
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius:28,
        backgroundImage: member.profileImageUrl != null ? NetworkImage(member.profileImageUrl!) : null,
        child: member.profileImageUrl==null ? Text(member.fullName.isNotEmpty ? member.fullName[0] : '?') : null,
      ),
      title: Text(member.fullName),
      subtitle: Text('Expiry: ${DateFormat.yMMMd().format(member.expiryDate)}',
        style: TextStyle(color: expired? Colors.red: null, fontWeight: expired? FontWeight.bold: null)),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
