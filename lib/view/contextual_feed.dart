import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fam_assignment/view_model/feed_view_model.dart';
import 'package:fam_assignment/models/card_model.dart';
import 'package:fam_assignment/widgets/card_widgets.dart';

class ContextualFeed extends StatefulWidget {
  const ContextualFeed({super.key});

  @override
  State<ContextualFeed> createState() => _ContextualFeedState();
}

class _ContextualFeedState extends State<ContextualFeed> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<FeedViewModel>();
      vm.clearSessionReminders();
      vm.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(vm.errorMessage!),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: vm.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final List<HcGroups> groups = vm.groups;
        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            itemBuilder: (context, index) {
              final group = groups[index];
              return _GroupWidget(group: group);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: groups.length,
          ),
        );
      },
    );
  }
}

class _GroupWidget extends StatelessWidget {
  final HcGroups group;
  const _GroupWidget({required this.group});

  @override
  Widget build(BuildContext context) {
    final cards = group.cards ?? [];
    final isScrollable = group.isScrollable ?? false;
    final designType = group.designType ?? '';

    Widget cardRow = _CardsRow(
      designType: designType,
      cards: cards,
      height: group.height,
      isScrollable: isScrollable,
    );

    if (isScrollable && designType != 'HC9') {
      cardRow = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: cardRow,
      );
    }
    return cardRow;
  }
}

class _CardsRow extends StatelessWidget {
  final String designType;
  final List<Cards> cards;
  final int? height;
  final bool isScrollable;

  const _CardsRow({
    required this.designType,
    required this.cards,
    this.height,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardWrapper(Widget cardWidget) {
      if (isScrollable) {
        return SizedBox(width: 200, child: cardWidget);
      }
      return Expanded(child: cardWidget);
    }

    switch (designType) {
      case 'HC1':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cards.map((c) => cardWrapper(HC1Card(card: c))).toList(),
        );
      case 'HC3':
        return Column(children: cards.map((c) => HC3Card(card: c)).toList());
      case 'HC5':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cards.map((c) => cardWrapper(HC5Card(card: c))).toList(),
        );
      case 'HC6':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cards.map((c) => cardWrapper(HC6Card(card: c))).toList(),
        );
      case 'HC9':
        final h = (height ?? 120).toDouble();
        return SizedBox(
          height: h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => HC9Card(card: cards[index]),
          ),
        );
      default:
        return Column(
          children: cards.map((c) => _PlaceholderCard(card: c)).toList(),
        );
    }
  }
}

class _PlaceholderCard extends StatelessWidget {
  final Cards card;
  const _PlaceholderCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<FeedViewModel>();
    final id = card.id ?? -1;
    return Dismissible(
      key: ValueKey('card_$id'),
      direction: DismissDirection.none,
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title ?? card.name ?? 'Card',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.description ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'remind') vm.remindLater(id);
                if (value == 'dismiss') vm.dismissNow(id);
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'remind',
                      child: Text('Remind later'),
                    ),
                    const PopupMenuItem(
                      value: 'dismiss',
                      child: Text('Dismiss now'),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
