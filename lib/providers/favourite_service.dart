import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  // Load favorite product IDs from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFavorites = prefs.getStringList('favorites') ?? [];
    state = storedFavorites.toSet();
  }

  // Add a product ID to favorites
  Future<void> addToFavorites(String productId) async {
    if (!state.contains(productId)) {
      final updatedFavorites = {...state, productId};
      state = updatedFavorites;
      await _persistFavorites();
    }
  }

  // Remove a product ID from favorites
  Future<void> removeFromFavorites(String productId) async {
    if (state.contains(productId)) {
      final updatedFavorites = {...state}..remove(productId);
      state = updatedFavorites;
      await _persistFavorites();
    }
  }

  // Persist the favorites to SharedPreferences
  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', state.toList());
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
  }
}

// Create a Riverpod provider for the FavoritesNotifier
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);
