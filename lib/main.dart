import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
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
      home: const FarmerShell(),
    );
  }
}
