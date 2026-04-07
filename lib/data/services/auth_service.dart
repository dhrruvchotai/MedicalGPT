import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();
  final _uuid = const Uuid();

  final Rx<UserModel> currentUser = Rx<UserModel>(UserModel.empty());
  final RxBool isLoggedIn = false.obs;

  // Mock user database (in-memory, persisted locally)
  final Map<String, Map<String, String>> _mockUsers = {};
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  void onInit() {
    super.onInit();
    _loadUsersDb();
    _loadPersistedUser();
  }

  void _loadUsersDb() {
    final jsonStr = _storage.usersDbJson;
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        _mockUsers.clear();
        decoded.forEach((key, value) {
          _mockUsers[key] = Map<String, String>.from(value);
        });
      } catch (e) {
        Get.log('Error loading users DB: $e');
      }
    }
  }

  Future<void> _persistUsersDb() async {
    await _storage.saveUsersDb(jsonEncode(_mockUsers));
  }

  void _loadPersistedUser() {
    final json = _storage.userDataJson;
    if (json != null && json.isNotEmpty) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        currentUser.value = UserModel.fromMap(map);
        isLoggedIn.value = true;
      } catch (_) {}
    }
  }

  Future<void> _persistUser(UserModel user) async {
    await _storage.saveUserData(jsonEncode(user.toMap()));
  }

  /// Mock Sign In
  Future<AuthResult> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    final key = email.trim().toLowerCase();
    if (_mockUsers.containsKey(key)) {
      if (_mockUsers[key]!['password'] == password) {
        final user = UserModel.fromMap({
          'id': _mockUsers[key]!['id']!,
          'name': _mockUsers[key]!['name']!,
          'email': email,
          'joinedDate': _mockUsers[key]!['joinedDate']!,
        });
        currentUser.value = user;
        isLoggedIn.value = true;
        await _persistUser(user);
        return AuthResult.success(user);
      } else {
        return AuthResult.failure('Incorrect password.');
      }
    }

    // Email not found — reject login
    return AuthResult.failure(
      'This email does not exist. Please create a new account.',
    );
  }

  /// Mock Sign Up
  Future<AuthResult> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final key = email.trim().toLowerCase();
    if (_mockUsers.containsKey(key)) {
      return AuthResult.failure('Email already in use.');
    }

    final id = _uuid.v4();
    _mockUsers[key] = {
      'id': id,
      'name': name.trim(),
      'password': password,
      'joinedDate': DateTime.now().toIso8601String(),
    };
    await _persistUsersDb();

    final user = UserModel(
      id: id,
      name: name.trim(),
      email: email.trim(),
      joinedDate: DateTime.now(),
    );

    currentUser.value = user;
    isLoggedIn.value = true;
    await _persistUser(user);
    return AuthResult.success(user);
  }

  /// Mock Google Sign In (Now actual Google Sign In)
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.failure('Google sign-in was canceled.');
      }

      final key = googleUser.email.trim().toLowerCase();
      String userId;
      DateTime joinedDate;

      if (_mockUsers.containsKey(key)) {
        userId = _mockUsers[key]!['id']!;
        joinedDate = DateTime.parse(_mockUsers[key]!['joinedDate']!);
        // Update name and photo in case it changed
        _mockUsers[key]!['name'] = googleUser.displayName ?? 'Google User';
        if (googleUser.photoUrl != null) {
          _mockUsers[key]!['photoUrl'] = googleUser.photoUrl!;
        }
      } else {
        userId = _uuid.v4();
        joinedDate = DateTime.now();
        _mockUsers[key] = {
          'id': userId,
          'name': googleUser.displayName ?? 'Google User',
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl ?? '',
          'joinedDate': joinedDate.toIso8601String(),
          'password': 'GOOGLE_AUTH_PLACEHOLDER_PASSWORD', // placeholder
        };
      }
      await _persistUsersDb();

      final user = UserModel(
        id: userId,
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
        joinedDate: joinedDate,
      );

      currentUser.value = user;
      isLoggedIn.value = true;
      await _persistUser(user);
      return AuthResult.success(user);
    } catch (e) {
      Get.log('Native Google Sign In Failed: $e. Using mock fallback.');
      
      final key = 'mock.google@gmail.com';
      String userId;
      DateTime joinedDate;

      if (_mockUsers.containsKey(key)) {
        userId = _mockUsers[key]!['id']!;
        joinedDate = DateTime.parse(_mockUsers[key]!['joinedDate']!);
      } else {
        userId = _uuid.v4();
        joinedDate = DateTime.now();
        _mockUsers[key] = {
          'id': userId,
          'name': 'Mock Google User',
          'email': 'mock.google@gmail.com',
          'photoUrl': 'https://ui-avatars.com/api/?name=Google+User&background=random',
          'joinedDate': joinedDate.toIso8601String(),
          'password': 'GOOGLE_AUTH_PLACEHOLDER_PASSWORD',
        };
        await _persistUsersDb();
      }

      final user = UserModel(
        id: userId,
        name: 'Mock Google User',
        email: 'mock.google@gmail.com',
        photoUrl: 'https://ui-avatars.com/api/?name=Google+User&background=random',
        joinedDate: joinedDate,
      );

      currentUser.value = user;
      isLoggedIn.value = true;
      await _persistUser(user);
      return AuthResult.success(user);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    currentUser.value = UserModel.empty();
    isLoggedIn.value = false;
    await _storage.clearUserData();
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    currentUser.value = currentUser.value.copyWith(
      name: name,
      photoUrl: photoUrl,
    );
    await _persistUser(currentUser.value);
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;

  const AuthResult._({required this.isSuccess, this.user, this.error});

  factory AuthResult.success(UserModel user) =>
      AuthResult._(isSuccess: true, user: user);

  factory AuthResult.failure(String error) =>
      AuthResult._(isSuccess: false, error: error);
}
