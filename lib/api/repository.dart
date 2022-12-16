import "package:flutter/foundation.dart";

abstract class Identifiable {
  int get id;
}

class CacheEntry<T> {
  final T value;
  final DateTime expiration;

  CacheEntry({required this.value, required this.expiration});
}

mixin Repository<T extends Identifiable> on ChangeNotifier {
  Duration get cacheExpiresIn;
  final Map<int, CacheEntry<T>> _cache = {};

  T cache(T model) {
    _cache[model.id] = CacheEntry(
        value: model, expiration: DateTime.now().add(cacheExpiresIn));

    // NOTE: This doesn't make sense yet, but I think it will be necessary
    // If we for example update a model that we read in some widget, we update it
    // in the cache, but we also need to rebuild that widget
    notifyListeners();
    return model;
  }

  Future<T> fromCache(int id, {required Future<T> Function() otherwise}) async {
    // This is basically _cache.putIfAbsent but async
    if (_cache.containsKey(id) &&
        _cache[id]!.expiration.isAfter(DateTime.now())) {
      return _cache[id]!.value;
    } else {
      try {
        return cache(await otherwise());
      } catch (error) {
        if (_cache.containsKey(id)) {
          // Return stale cache if refetching fails
          return _cache[id]!.value;
        } else {
          rethrow;
        }
      }
    }
  }
}