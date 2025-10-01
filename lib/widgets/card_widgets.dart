import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:fam_assignment/models/card_model.dart';
import 'package:fam_assignment/view_model/feed_view_model.dart';
import 'package:fam_assignment/widgets/formatted_text_widget.dart';
import 'package:fam_assignment/utils/utils.dart';

// HC1 - Small Display Card
class HC1CardWrapper extends StatelessWidget {
  final List<Cards> cards;
  final bool isScrollable;

  const HC1CardWrapper({
    super.key,
    required this.cards,
    required this.isScrollable,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSpacing = 15.0;

    return SingleChildScrollView(
      scrollDirection: isScrollable ? Axis.horizontal : Axis.vertical,
      child: Row(
        children:
            cards.map((card) {
              double cardWidth;

              if (cards.length == 1) {
                cardWidth = screenWidth;
              } else if (!isScrollable) {
                cardWidth =
                    (screenWidth - (cards.length + 1) * cardSpacing) /
                    cards.length;
              } else {
                cardWidth = screenWidth * 0.64;
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: cardSpacing / 2),
                child: SizedBox(width: cardWidth, child: HC1Card(card: card)),
              );
            }).toList(),
      ),
    );
  }
}

class HC1Card extends StatelessWidget {
  final Cards card;
  const HC1Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCardTap(card, context),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: _parseColor(card.bgColor) ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ICON LEFT
            if (card.icon != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: card.icon!.imageUrl ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // TEXT BLOCK
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // vertical center
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormattedTextWidget(
                    formattedTitle: card.formattedTitle,
                    fallbackText: card.title,
                    baseStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  if (card.formattedDescription != null ||
                      card.description != null) ...[
                    const SizedBox(height: 2),
                    FormattedTextWidget(
                      formattedTitle: card.formattedDescription,
                      fallbackText: card.description,
                      baseStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  if (card.cta != null && card.cta!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () => _handleCtaTap(card.cta!.first, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _parseColor(card.cta!.first.bgColor) ??
                            Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: const Size(0, 32), // fits 64px height
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        card.cta!.first.text ?? 'Action',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HC3 - Big Display Card with Action
class HC3Card extends StatefulWidget {
  final Cards card;
  const HC3Card({super.key, required this.card});

  @override
  State<HC3Card> createState() => _HC3CardState();
}

class _HC3CardState extends State<HC3Card> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.3, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _handleLongPress,
      onTap: () => _handleCardTap(widget.card, context),
      child: Stack(
        children: [
          if (_isSliding) _buildActionButtons(),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: _slideAnimation.value,
                child: _buildMainCard(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.schedule,
              label: 'Remind later',
              onTap: () => _handleRemindLater(),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.close,
              label: 'Dismiss now',
              onTap: () => _handleDismissNow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      height: 350.px,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.px, vertical: 24.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient:
            widget.card.bgGradient != null
                ? LinearGradient(
                  colors:
                      widget.card.bgGradient!.colors!
                          .map((c) => _parseColor(c) ?? Colors.white)
                          .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color:
            widget.card.bgGradient == null
                ? (_parseColor(widget.card.bgColor) ?? Colors.blue)
                : null,
        image:
            widget.card.bgImage != null
                ? DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.card.bgImage!.imageUrl ?? '',
                  ),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.card.icon != null) ...[
              CachedNetworkImage(
                imageUrl: widget.card.icon!.imageUrl ?? '',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
              ),
              const SizedBox(height: 16),
            ],

            // Take all space and push text+button to bottom
            const Spacer(),

            // Text from API (title + description)
            FormattedTextWidget(
              formattedTitle: widget.card.formattedTitle,
              fallbackText: widget.card.title,
              baseStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            FormattedTextWidget(
              formattedTitle: widget.card.formattedDescription,
              fallbackText: widget.card.description,
              baseStyle: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 4),

            // Button at bottom-left
            if (widget.card.cta != null && widget.card.cta!.isNotEmpty)
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed:
                      () => _handleCtaTap(widget.card.cta!.first, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _parseColor(widget.card.cta!.first.bgColor) ??
                        Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(widget.card.cta!.first.text ?? ''),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleLongPress() {
    setState(() {
      _isSliding = true;
    });
    _animationController.forward();
  }

  void _handleRemindLater() {
    final vm = context.read<FeedViewModel>();
    vm.remindLater(widget.card.id ?? -1);
    _resetCard();
  }

  void _handleDismissNow() {
    final vm = context.read<FeedViewModel>();
    vm.dismissNow(widget.card.id ?? -1);
    _resetCard();
  }

  void _resetCard() {
    _animationController.reverse().then((_) {
      setState(() {
        _isSliding = false;
      });
    });
  }
}

// HC5 - Image Card
class HC5Card extends StatelessWidget {
  final Cards card;
  const HC5Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCardTap(card, context),
      child: Container(
        height: 129.px,
        margin: EdgeInsets.symmetric(horizontal: 20.px, vertical: 15.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image:
              card.bgImage != null
                  ? DecorationImage(
                    image: CachedNetworkImageProvider(
                      card.bgImage!.imageUrl ?? '',
                    ),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FormattedTextWidget(
                formattedTitle: card.formattedTitle,
                fallbackText: card.title,
                baseStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (card.formattedDescription != null ||
                  card.description != null) ...[
                const SizedBox(height: 8),
                FormattedTextWidget(
                  formattedTitle: card.formattedDescription,
                  fallbackText: card.description,
                  baseStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// HC6 - Small Card with Arrow
class HC6Card extends StatelessWidget {
  final Cards card;
  const HC6Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCardTap(card, context),
      child: Container(
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: _parseColor(card.bgColor) ?? Colors.yellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (card.icon != null) ...[
              const SizedBox(width: 12),
              CachedNetworkImage(
                imageUrl: card.icon!.imageUrl ?? '',
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      width: 24,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: 24,
                      height: 24,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 16),
                    ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FormattedTextWidget(
                formattedTitle: card.formattedTitle,
                fallbackText: card.title ?? '',
                baseStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

// HC9 - Dynamic Width Card
class HC9Group extends StatelessWidget {
  final List<Cards> cards;
  final bool isScrollable;
  final bool isFullWidth;

  const HC9Group({
    super.key,
    required this.cards,
    this.isScrollable = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    const double fixedHeight = 195;

    final content = Row(
      children:
          cards.map((card) {
            return HC9Card(card: card);
          }).toList(),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child:
          isScrollable
              ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: content,
              )
              : content,
    );
  }
}

class HC9Card extends StatelessWidget {
  final Cards card;

  const HC9Card({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    const double fixedHeight = 195;
    final double cardWidth =
        card.bgImage?.aspectRatio != null
            ? fixedHeight * card.bgImage!.aspectRatio!
            : fixedHeight * 0.8;

    return Container(
      height: fixedHeight,
      width: cardWidth,
      margin: const EdgeInsets.only(right: 15), // spacing between cards
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient:
            card.bgGradient != null
                ? LinearGradient(
                  colors:
                      card.bgGradient!.colors!
                          .map((c) => _parseColor(c) ?? Colors.blue)
                          .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color:
            card.bgGradient == null
                ? (_parseColor(card.bgColor) ?? Colors.blue)
                : null,
        image:
            card.bgImage != null
                ? DecorationImage(
                  image: CachedNetworkImageProvider(
                    card.bgImage!.imageUrl ?? '',
                  ),
                  fit: BoxFit.cover,
                )
                : null,
      ),
    );
  }
}

// Helper functions
Color? _parseColor(String? colorString) {
  if (colorString == null || colorString.isEmpty) return null;
  try {
    return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
  } catch (e) {
    return null;
  }
}

void _handleCardTap(Cards card, BuildContext context) {
  if (card.url != null && card.url!.isNotEmpty) {
    _launchUrl(card.url!, context);
  }
}

void _handleCtaTap(Cta cta, BuildContext context) {
  if (cta.text != null && cta.text!.isNotEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('CTA tapped: ${cta.text}')));
  }
}

Future<void> _launchUrl(String url, BuildContext context) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  } catch (e) {
    debugPrint(e.toString());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error launching URL: $e')));
  }
}
