import "package:flutter/foundation.dart";

abstract class Identifiable {
  int get id;
}

mixin Repository<T extends Identifiable> on ChangeNotifier {
  final Map<int, T> _cache = {};

  T cache(T model) {
    _cache[model.id] = model;
    // NOTE: This doesn't make sense yet, but I think it will be necessary
    // If we for example update a model that we read in some widget, we update it
    // in the cache, but we also need to rebuild that widget
    notifyListeners();
    return model;
  }

  Future<T> fromCache(int id, {required Future<T> Function() otherwise}) async {
    // This is basically _cache.putIfAbsent but async
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    } else {
      final model = await otherwise();
      _cache[id] = model;
      return model;
    }
  }
}
