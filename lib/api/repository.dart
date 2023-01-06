import "package:flutter/foundation.dart";

abstract class Identifiable {
  int get id;
}

class CacheEntry<T> {
  final T value;
  final DateTime expiration;

  CacheEntry({required this.value, required this.expiration});
}

abstract class Repository<T extends Identifiable> extends ChangeNotifier {
  Duration get cacheExpiresIn;
  DateTime? _indexExpiration;
  final Map<int, CacheEntry<T>> _cache = {};

  T cache(T model, {bool notifyListeners = false}) {
    _cache[model.id] = CacheEntry(
        value: model, expiration: DateTime.now().add(cacheExpiresIn));

    if (notifyListeners) this.notifyListeners();

    return model;
  }

  Future<T> fetchCached(int id, Future<T> Function() fetch) async {
    // This is basically _cache.putIfAbsent but async
    if (_cache.containsKey(id) &&
        _cache[id]!.expiration.isAfter(DateTime.now())) {
      return _cache[id]!.value;
    }

    try {
      return cache(await fetch());
    } catch (error) {
      // Return stale cache if refetching fails
      if (_cache.containsKey(id)) return _cache[id]!.value;
      rethrow;
    }
  }

  /// Checks if the last fetched index is valid, and returns all cached records,
  /// or if not - calls the given callback which is supposed to fetch the index.
  /// The new collection of records is then returned. Before the cache is
  /// repopulated, it is cleared to get rid of records which no longer exist.
  Future<Iterable<T>> fetchAllCached(
      Future<Iterable<T>> Function() fetch) async {
    if (_indexExpiration != null && _indexExpiration!.isAfter(DateTime.now())) {
      return _cache.values.map((e) => e.value);
    }

    try {
      final records = await fetch();
      _cache.clear();

      for (final record in records) {
        cache(record, notifyListeners: false);
      }

      _indexExpiration = DateTime.now().add(cacheExpiresIn);
      notifyListeners();
    } catch (error) {
      if (_indexExpiration == null) rethrow;
    }

    return _cache.values.map((e) => e.value);
  }
}
