import 'package:flutter/foundation.dart';

class FarmerUser {
  final String name;
  final String mobileNumber;
  final String village;
  final String district;
  final String state;
  final String farmSize;
  final String mainCrops;

  const FarmerUser({
    required this.name,
    required this.mobileNumber,
    required this.village,
    required this.district,
    required this.state,
    this.farmSize = '5 Acres',
    this.mainCrops = 'Tomato, Wheat, Onion',
  });
}

class AuthService extends ChangeNotifier {
  // Singleton pattern
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  // In-memory mock registered farmers (seeded with demo farmer)
  final Map<String, String> _passwords = {
    '9876543210': 'password123',
    '9898989898': 'farmer123',
  };

  final Map<String, FarmerUser> _users = {
    '9876543210': const FarmerUser(
      name: 'Suresh Patil',
      mobileNumber: '9876543210',
      village: 'Haveli',
      district: 'Pune',
      state: 'Maharashtra',
      farmSize: '5 Acres',
      mainCrops: 'Tomato, Wheat, Onion',
    ),
  };

  FarmerUser? _currentUser;
  bool _isLoggedIn = false;

  FarmerUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  /// Mock login with mobile number and password
  Future<String?> login(String mobileNumber, String password) async {
    // Simulate slight network latency
    await Future.delayed(const Duration(milliseconds: 600));

    final trimmedMobile = mobileNumber.trim().replaceAll(RegExp(r'\D'), '');
    final trimmedPassword = password.trim();

    if (trimmedMobile.isEmpty || trimmedPassword.isEmpty) {
      return 'Please enter both mobile number and password.';
    }

    if (trimmedMobile.length != 10) {
      return 'Please enter a valid 10-digit mobile number.';
    }

    // Check if user exists
    if (!_passwords.containsKey(trimmedMobile)) {
      // For user friendliness, accept any password if it's a freshly entered mobile or create mock session
      _users[trimmedMobile] = FarmerUser(
        name: 'Farmer ($trimmedMobile)',
        mobileNumber: trimmedMobile,
        village: 'Pune Rural',
        district: 'Pune',
        state: 'Maharashtra',
      );
      _passwords[trimmedMobile] = trimmedPassword;
    } else if (_passwords[trimmedMobile] != trimmedPassword) {
      return 'Incorrect password. Try password123 or check your details.';
    }

    _currentUser = _users[trimmedMobile];
    _isLoggedIn = true;
    notifyListeners();
    return null; // null means success
  }

  /// Mock registration for a new farmer
  Future<String?> register({
    required String name,
    required String mobileNumber,
    required String password,
    required String confirmPassword,
    required String village,
    required String district,
    required String state,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final trimmedName = name.trim();
    final trimmedMobile = mobileNumber.trim().replaceAll(RegExp(r'\D'), '');
    final trimmedPassword = password.trim();
    final trimmedConfirm = confirmPassword.trim();
    final trimmedVillage = village.trim();
    final trimmedDistrict = district.trim();
    final trimmedState = state.trim();

    if (trimmedName.isEmpty) return 'Farmer Name is required.';
    if (trimmedMobile.length != 10) return 'Please enter a valid 10-digit mobile number.';
    if (trimmedPassword.length < 6) return 'Password must be at least 6 characters.';
    if (trimmedPassword != trimmedConfirm) return 'Passwords do not match.';
    if (trimmedVillage.isEmpty) return 'Village name is required.';
    if (trimmedDistrict.isEmpty) return 'District name is required.';
    if (trimmedState.isEmpty) return 'State name is required.';

    // Save user
    final newUser = FarmerUser(
      name: trimmedName,
      mobileNumber: trimmedMobile,
      village: trimmedVillage,
      district: trimmedDistrict,
      state: trimmedState,
    );

    _users[trimmedMobile] = newUser;
    _passwords[trimmedMobile] = trimmedPassword;
    notifyListeners();
    return null; // success
  }

  /// Logout current farmer
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
