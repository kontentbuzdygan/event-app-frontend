import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";

class DiscoverScreenNotifier extends ChangeNotifier {
  String? _filterText;
  final Set<String> _filterTags = {};
  Set<String> get filterTags => _filterTags;

  bool _mapOpened = false;
  bool get mapOpened => _mapOpened;
  set mapOpened(bool v) {
    _mapOpened = v;
    notifyListeners();
  }

  final sheetController = DraggableScrollableController();

  void addFilterTag(String tag) {
    _filterTags.add(tag);
    notifyListeners();
  }

  void removeFilterTag(String tag) {
    _filterTags.remove(tag);
    notifyListeners();
  }

  void setFilterText(String? newText) {
    _filterText = newText?.toLowerCase();
    notifyListeners();
  }

  void toggleList() {
    sheetController.animateTo(
      _mapOpened ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool filterEvent(Event event) {
    if (_filterText == null) return true;

    return event.title.toLowerCase().contains(_filterText!) ||
        (event.author?.displayName.toLowerCase().contains(_filterText!) ??
            false);
  }
}
