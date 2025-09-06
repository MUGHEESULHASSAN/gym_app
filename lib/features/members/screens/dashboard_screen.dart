
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/members_provider.dart';
import '../../auth/screens/login_screen.dart';
import 'members_list_screen.dart';
import 'add_edit_member_screen.dart';
import '../../../core/widgets/primary_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MembersProvider>().loadMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GymFlow Dashboard'),
        actions: [
          IconButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())), icon: const Icon(Icons.logout)),
        ],
      ),
      body: Consumer<MembersProvider>(
        builder: (context, provider, _) {
          final total = provider.members.length;
          final now = DateTime.now();
          final expiringSoon = provider.members.where((m) => m.expiryDate.isBefore(now.add(const Duration(days:7)))).length;
          // today's checkins would require aggregation; placeholder:
          const todaysCheckins = 0;
          return RefreshIndicator(
            onRefresh: provider.loadMembers,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Total Active Members: $total', style: const TextStyle(fontSize:18)),
                    const SizedBox(height:8),
                    Text('Memberships expiring in 7 days: $expiringSoon'),
                    const SizedBox(height:8),
                    Text('Today\'s check-ins: $todaysCheckins'),
                  ]),
                )),
                const SizedBox(height:20),
                PrimaryButton(label: 'Add Member', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditMemberScreen()))),
                const SizedBox(height:12),
                PrimaryButton(label: 'View All Members', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MembersListScreen()))),
              ],
            ),
          );
        },
      ),
    );
  }
}
