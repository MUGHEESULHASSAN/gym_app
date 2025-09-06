
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/members_provider.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/member_card.dart';
import 'member_detail_screen.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({super.key});

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MembersProvider>().loadMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: CustomTextFormField(label: 'Search by name', controller: _searchCtrl, onTap: null)),
          Expanded(child: Consumer<MembersProvider>(
            builder: (context, provider, _) {
              final list = provider.members;
              if (provider.loading) return const Center(child: CircularProgressIndicator());
              if (list.isEmpty) return const Center(child: Text('No members yet'));
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final m = list[index];
                  return MemberCard(member: m, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MemberDetailScreen(member: m)));
                  });
                });
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MembersListScreen())), child: const Icon(Icons.search)),
    );
  }
}
