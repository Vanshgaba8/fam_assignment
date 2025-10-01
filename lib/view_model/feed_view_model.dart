import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fam_assignment/models/card_model.dart';
import 'package:fam_assignment/repository/feed_repository.dart';

class FeedViewModel extends ChangeNotifier {
  final FeedRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<HcGroups> _groups = [];

  Set<int> _dismissedCardIds = <int>{};

  Set<int> _remindLaterCardIds = <int>{};

  FeedViewModel({FeedRepository? repository})
    : _repository = repository ?? FeedRepository() {
    _loadDismissedCards();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<HcGroups> get groups => _filteredGroups();

  Future<void> initialize() async {
    await _loadDismissedCards();
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

  Future<void> _loadDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedList = prefs.getStringList('dismissed_card_ids') ?? [];
    _dismissedCardIds =
        dismissedList
            .map((e) => int.tryParse(e) ?? -1)
            .where((id) => id != -1)
            .toSet();
  }

  Future<void> _saveDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'dismissed_card_ids',
      _dismissedCardIds.map((e) => e.toString()).toList(),
    );
  }

  // Remind later
  void remindLater(int cardId) {
    _remindLaterCardIds.add(cardId);
    notifyListeners();
  }

  // Dismiss now
  void dismissNow(int cardId) {
    _dismissedCardIds.add(cardId);
    _remindLaterCardIds.remove(
      cardId,
    ); // Remove from remind later if it was there
    _saveDismissedCards();
    notifyListeners();
  }

  // Clear remind later cards on app restart
  void clearSessionReminders() {
    _remindLaterCardIds.clear();
    notifyListeners();
  }

  // Check visibility based on both factors
  bool isCardVisible(int cardId) {
    // Hide if dismissed
    if (_dismissedCardIds.contains(cardId)) return false;
    // Hide if remind later
    if (_remindLaterCardIds.contains(cardId)) return false;
    return true;
  }

  List<HcGroups> _filteredGroups() {
    if (_groups.isEmpty) return _groups;

    final List<HcGroups> filtered = [];
    for (final group in _groups) {
      final visibleCards =
          (group.cards ?? []).where((card) {
            final cardId = card.id ?? -1;
            return isCardVisible(cardId);
          }).toList();

      if (visibleCards.isNotEmpty) {
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
            cards: visibleCards,
          ),
        );
      }
    }
    return filtered;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
