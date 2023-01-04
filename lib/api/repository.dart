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
  CacheEntry<List<int>>? _idsCache;
  // TODO: We might need to additionally distinguish between "simple" and "detailed" views
  // Should just involve extending the key
  final Map<int, CacheEntry<T>> _cache = {};

  T cache(T model) {
    _cache[model.id] = CacheEntry(
        value: model, expiration: DateTime.now().add(cacheExpiresIn));

    _idsCache?.value.add(model.id);
    notifyListeners();
    return model;
  }

  Future<T> fetchCached(int id, Future<T> Function() otherwise) async {
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

  Future<List<int>> fetchIdsCached(
      Future<List<int>> Function() otherwise) async {
    if (_idsCache != null && _idsCache!.expiration.isAfter(DateTime.now())) {
      return _idsCache!.value;
    } else {
      try {
        final ids = await otherwise();
        _idsCache = CacheEntry(
            value: ids, expiration: DateTime.now().add(cacheExpiresIn));
        return _idsCache!.value;
      } catch (error) {
        if (_idsCache != null) {
          return _idsCache!.value;
        } else {
          rethrow;
        }
      }
    }
  }
}
