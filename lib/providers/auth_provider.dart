import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String? email;

  const AuthState({required this.isLoggedIn, this.email});

  AuthState copyWith({bool? isLoggedIn, String? email}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage;

  AuthNotifier(this._storage) : super(const AuthState(isLoggedIn: false)) {
    _restoreAuthState();
  }

  static const _emailKey = 'auth_email';
  static const _passwordKey = 'auth_password';

  Future<void> registration(String email, String password) async {
    // Save email and password to secure storage
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<void> login(String email, String password) async {
    final storedEmail = await _storage.read(key: _emailKey);
    final storedPassword = await _storage.read(key: _passwordKey);
    if (storedEmail == email && storedPassword == password) {
      state = AuthState(isLoggedIn: true, email: email);
    } else {
      state = const AuthState(isLoggedIn: false, email: "");
    }
  }

  Future<void> updateEmail(String email) async {
    // Update email to secure storage
    await _storage.write(key: _emailKey, value: email);
    // Update state
    state = AuthState(isLoggedIn: true, email: email);
  }

  Future<void> logout() async {
    // Clear stored data
    await _storage.deleteAll();

    // Update state
    state = const AuthState(isLoggedIn: false);
  }

  Future<void> _restoreAuthState() async {
    final email = await _storage.read(key: _emailKey);

    if (email != null) {
      state = AuthState(isLoggedIn: true, email: email);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  const secureStorage = FlutterSecureStorage();
  return AuthNotifier(secureStorage);
});
