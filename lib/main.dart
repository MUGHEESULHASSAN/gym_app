import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/members/providers/members_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/members/screens/dashboard_screen.dart';
import 'features/splash/splash_screen.dart'; // ✅ Import SplashScreen
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const GymFlowApp());
}

class GymFlowApp extends StatelessWidget {
  const GymFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MembersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GymFlow',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(), // ✅ Start from splash screen
        routes: {
          '/login': (_) => const LoginScreen(),
          '/dashboard': (_) => const DashboardScreen(),
        },
      ),
    );
  }
}
