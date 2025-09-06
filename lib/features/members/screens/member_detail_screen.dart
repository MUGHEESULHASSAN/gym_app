
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';
import '../providers/members_provider.dart';
import '../../../core/widgets/primary_button.dart';
import 'add_edit_member_screen.dart';
import 'package:intl/intl.dart';

class MemberDetailScreen extends StatefulWidget {
  final Member member;
  const MemberDetailScreen({super.key, required this.member});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  late Future<List<DateTime>> attendanceFuture;

  @override
  void initState() {
    super.initState();
    attendanceFuture = context.read<MembersProvider>().getAttendance(widget.member.id);
  }

  @override
  Widget build(BuildContext context) {
    final expired = widget.member.expiryDate.isBefore(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text(widget.member.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          CircleAvatar(radius:48, backgroundImage: widget.member.profileImageUrl!=null ? NetworkImage(widget.member.profileImageUrl!) : null, child: widget.member.profileImageUrl==null ? Text(widget.member.fullName[0]) : null),
          const SizedBox(height:12),
          Text(widget.member.fullName, style: const TextStyle(fontSize:22,fontWeight: FontWeight.bold)),
          const SizedBox(height:8),
          Text(widget.member.email),
          const SizedBox(height:8),
          Text(widget.member.phone),
          const SizedBox(height:12),
          Text('Plan: ${widget.member.plan}'),
          const SizedBox(height:8),
          Text('Start: ${DateFormat.yMMMd().format(widget.member.startDate)}'),
          const SizedBox(height:8),
          Text('Expiry: ${DateFormat.yMMMd().format(widget.member.expiryDate)}', style: TextStyle(color: expired? Colors.red: null, fontWeight: expired? FontWeight.bold: null)),
          const SizedBox(height:16),
          PrimaryButton(label: 'Check-in Today', onPressed: () async {
            await context.read<MembersProvider>().checkIn(widget.member.id);
            setState(() { attendanceFuture = context.read<MembersProvider>().getAttendance(widget.member.id); });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked in')));
          }),
          const SizedBox(height:12),
          PrimaryButton(label: 'Edit Member', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditMemberScreen(editMember: widget.member)))),
          const SizedBox(height:20),
          const Text('Attendance', style: TextStyle(fontSize:18)),
          const SizedBox(height:8),
          FutureBuilder<List<DateTime>>(future: attendanceFuture, builder: (context, snap) {
            if (snap.connectionState==ConnectionState.waiting) return const CircularProgressIndicator();
            if (snap.hasError) return const Text('Error: \${snap.error}');
            final list = snap.data ?? [];
            if (list.isEmpty) return const Text('No attendance records');
            return Column(children: list.map((d) => ListTile(title: Text(DateFormat.yMMMd().add_jm().format(d)))).toList());
          })
        ]),
      ),
    );
  }
}
