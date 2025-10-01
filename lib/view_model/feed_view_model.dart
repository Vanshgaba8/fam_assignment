import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fam_assignment/models/card_model.dart';
import 'package:fam_assignment/repository/feed_repository.dart';

class FeedViewModel extends ChangeNotifier {
  final FeedRepository _repository;
  FeedViewModel({FeedRepository? repository})
    : _repository = repository ?? FeedRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<HcGroups> _groups = [];

  static const String _dismissedKey = 'dismissed_card_ids';
  static const String _remindLaterKey = 'remind_later_card_ids';

  Set<int> _dismissedIds = <int>{};
  Set<int> _remindLaterIds = <int>{};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<HcGroups> get groups => _filteredGroups();

  Future<void> initialize() async {
    await _loadPrefs();
    await refresh();
  }

  Future<void> refresh() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _groups = await _repository.fetchFeedGroups();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void remindLater(int cardId) {
    _remindLaterIds.add(cardId);
    notifyListeners();
    _savePrefs();
  }

  void dismissNow(int cardId) {
    _dismissedIds.add(cardId);
    _remindLaterIds.remove(cardId);
    notifyListeners();
    _savePrefs();
  }

  void clearSessionReminders() {
    _remindLaterIds.clear();
    notifyListeners();
  }

  List<HcGroups> _filteredGroups() {
    if (_groups.isEmpty) return _groups;
    final List<HcGroups> filtered = [];
    for (final group in _groups) {
      final cards =
          (group.cards ?? []).where((c) {
            final id = c.id ?? -1;
            if (_dismissedIds.contains(id)) return false;
            if (_remindLaterIds.contains(id)) return false;
            return true;
          }).toList();
      if (cards.isNotEmpty) {
        filtered.add(
          HcGroups(
            id: group.id,
            name: group.name,
            designType: group.designType,
            cardType: group.cardType,
            isScrollable: group.isScrollable,
            height: group.height,
            isFullWidth: group.isFullWidth,
            slug: group.slug,
            level: group.level,
            cards: cards,
          ),
        );
      }
    }
    return filtered;
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _dismissedIds =
        (prefs.getStringList(_dismissedKey) ?? []).map(int.parse).toSet();
    _remindLaterIds =
        (prefs.getStringList(_remindLaterKey) ?? []).map(int.parse).toSet();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _dismissedKey,
      _dismissedIds.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList(
      _remindLaterKey,
      _remindLaterIds.map((e) => e.toString()).toList(),
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
