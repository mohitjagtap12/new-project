import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/primary_button.dart';
import '../farmer/farmer_shell.dart';
import 'auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController(text: '9876543210');
  final _passwordController = TextEditingController(text: 'password123');

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final error = await AuthService.instance.login(
      _mobileController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      AppUtils.showSnackBar(context, error, isError: true);
    } else {
      AppUtils.showSnackBar(context, 'Login successful! Welcome to AgroWorld.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FarmerShell()),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final resetPhoneCtrl = TextEditingController(text: _mobileController.text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: AgroColors.primary),
            SizedBox(width: 8),
            Text('Forgot Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered 10-digit mobile number. We will send a verification code (OTP) to reset your password.',
              style: TextStyle(fontSize: 13, color: AgroColors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetPhoneCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone_outlined, color: AgroColors.primary),
                hintText: '10 digit mobile number',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AgroColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppUtils.showSnackBar(
                context,
                'Password reset instructions sent to ${resetPhoneCtrl.text.trim().isEmpty ? 'your mobile' : resetPhoneCtrl.text}',
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(110, 44),
              backgroundColor: AgroColors.primary,
            ),
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AgroColors.border, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // AgroWorld Logo & Header
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AgroColors.primary,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AgroColors.primary.withOpacity(0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // AgroWorld Name
                        const Text(
                          AppConstants.appName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AgroColors.primaryDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Farmer Login Title
                        const Text(
                          'Farmer Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AgroColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),

                        const Text(
                          'Login to manage crops, labour, orders & market',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AgroColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Mobile Number Field
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number *',
                            hintText: 'Enter 10-digit mobile number',
                            prefixIcon: Icon(Icons.phone_android_rounded, color: AgroColors.primary),
                            prefixText: '+91 ',
                            prefixStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AgroColors.textDark,
                              fontSize: 15,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Mobile number is required';
                            }
                            if (val.trim().length != 10) {
                              return 'Enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AgroColors.primary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AgroColors.textMuted,
                              ),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (val.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _showForgotPasswordDialog,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AgroColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Button
                        PrimaryButton(
                          label: 'Login',
                          icon: Icons.login_rounded,
                          isLoading: _isLoading,
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 16),

                        // Demo Account Quick Tap helper
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AgroColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AgroColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: AgroColors.primary),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Demo Login: 9876543210 / password123',
                                  style: TextStyle(fontSize: 11, color: AgroColors.textMuted),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _mobileController.text = '9876543210';
                                  _passwordController.text = 'password123';
                                  AppUtils.showSnackBar(context, 'Filled demo farmer credentials');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  child: Text(
                                    'Fill',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AgroColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Create Account Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(fontSize: 14, color: AgroColors.textMuted),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AgroColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
