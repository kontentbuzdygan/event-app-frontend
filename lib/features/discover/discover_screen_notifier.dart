import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/rest_client.dart";
import "package:flutter/material.dart";

class DiscoverPageNotifier extends ChangeNotifier {
  DiscoverPageNotifier() {
    fetchEvents();
    fetchProfiles();
  }

  String? _filterText;
  final Set<String> _filterTags = {};
  Set<String> get filterTags => _filterTags;

  bool _mapOpened = false;
  bool get mapOpened => _mapOpened;
  set mapOpened(bool v) {
    _mapOpened = v;
    notifyListeners();
  }

  List<Profile>? profiles;
  List<Event>? events;

  final sheetController = DraggableScrollableController();

  Future<void> fetchEvents() async {
    final e = (await Event.findAll()).toList();
    await RestClient.runCached(
      () => Future.wait(
        e.map((event) => event.fetchAuthor()),
      ),
    );
    events = e;
    notifyListeners();
  }

  Future<void> fetchProfiles() async {
    if ((_filterText?.length ?? 0) < 3) {
      profiles = [];
      notifyListeners();
      return;
    }

    profiles = null;
    notifyListeners();
    profiles = await Profile.search(_filterText ?? "");
    notifyListeners();
  }

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
    fetchProfiles();
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
