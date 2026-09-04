import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/primary_button.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _villageController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController(text: 'Maharashtra');

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final error = await AuthService.instance.register(
      name: _nameController.text,
      mobileNumber: _mobileController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      village: _villageController.text,
      district: _districtController.text,
      state: _stateController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      AppUtils.showSnackBar(context, error, isError: true);
    } else {
      AppUtils.showSnackBar(context, 'Account created successfully! Please login with your credentials.');
      Navigator.of(context).pop(); // Return to Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroColors.background,
      appBar: AppBar(
        title: const Text('Farmer Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back to Login',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AgroColors.border, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Icon & Title
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AgroColors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1_rounded,
                                color: AgroColors.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create Farmer Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AgroColors.textDark,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Join AgroWorld to connect with buyers and services',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AgroColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32, color: AgroColors.border),

                        // 1. Farmer Name Field
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Farmer Full Name *',
                            hintText: 'e.g. Suresh Tukaram Patil',
                            prefixIcon: Icon(Icons.person_outline_rounded, color: AgroColors.primary),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 2. Mobile Number Field
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number *',
                            hintText: '10-digit mobile number',
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
                              return 'Please enter mobile number';
                            }
                            if (val.trim().length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 3. Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            hintText: 'Minimum 6 characters',
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
                              return 'Please enter a password';
                            }
                            if (val.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 4. Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password *',
                            hintText: 'Re-enter your password',
                            prefixIcon: const Icon(Icons.lock_reset_rounded, color: AgroColors.primary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AgroColors.textMuted,
                              ),
                              onPressed: () {
                                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                              },
                              tooltip: _obscureConfirmPassword ? 'Show password' : 'Hide password',
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (val != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 5. Village Field
                        TextFormField(
                          controller: _villageController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Village *',
                            hintText: 'e.g. Haveli, Baramati',
                            prefixIcon: Icon(Icons.home_work_outlined, color: AgroColors.primary),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Village name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 6 & 7. District & State in Responsive Row/Column
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmall = constraints.maxWidth < 360;

                            final districtField = TextFormField(
                              controller: _districtController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'District *',
                                hintText: 'e.g. Pune',
                                prefixIcon: Icon(Icons.location_city_outlined, color: AgroColors.primary),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'District required';
                                }
                                return null;
                              },
                            );

                            final stateField = TextFormField(
                              controller: _stateController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'State *',
                                hintText: 'e.g. Maharashtra',
                                prefixIcon: Icon(Icons.map_outlined, color: AgroColors.primary),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'State required';
                                }
                                return null;
                              },
                            );

                            if (isSmall) {
                              return Column(
                                children: [
                                  districtField,
                                  const SizedBox(height: 16),
                                  stateField,
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: districtField),
                                const SizedBox(width: 12),
                                Expanded(child: stateField),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 28),

                        // Create Account Button
                        PrimaryButton(
                          label: 'Create Account',
                          icon: Icons.check_circle_outline_rounded,
                          isLoading: _isLoading,
                          onPressed: _handleRegister,
                        ),
                        const SizedBox(height: 16),

                        // Back to Login Button / Link
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Back to Login'),
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
