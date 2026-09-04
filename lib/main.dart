import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/farmer/farmer_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AgroWorldFarmerApp());
}

class AgroWorldFarmerApp extends StatelessWidget {
  const AgroWorldFarmerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroWorld',
      debugShowCheckedModeBanner: false,
      theme: AgroTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.farmerShell: (_) => const FarmerShell(),
      },
    );
  }
}

