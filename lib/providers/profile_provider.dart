import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileState {
  final String? profileImagePath;
  final String? name;

  ProfileState({this.profileImagePath, this.name});

  ProfileState copyWith({String? profileImagePath, String? name}) {
    return ProfileState(
      profileImagePath: profileImagePath ?? this.profileImagePath,
      name: name ?? this.name,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState()) {
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final profileImagePath = prefs.getString('profileImagePath');
    final name = prefs.getString('profileName');

    state = ProfileState(
      profileImagePath: profileImagePath,
      name: name,
    );
  }

  Future<void> updateProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);

    state = state.copyWith(profileImagePath: path);
  }

  Future<void> updateName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileName', name);

    state = state.copyWith(name: name);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
