import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fam_assignment/models/card_model.dart';

class FormattedTextWidget extends StatelessWidget {
  final FormattedTitle? formattedTitle;
  final String? fallbackText;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;

  const FormattedTextWidget({
    super.key,
    this.formattedTitle,
    this.fallbackText,
    this.baseStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    if (formattedTitle?.text == null || formattedTitle!.text!.isEmpty) {
      return Text(fallbackText ?? '', style: baseStyle, textAlign: textAlign);
    }

    final text = formattedTitle!.text!;
    final entities = formattedTitle!.entities ?? [];

    if (entities.isEmpty) {
      return Text(text, style: baseStyle, textAlign: textAlign);
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.left,
      text: _buildTextSpan(text, entities, context),
    );
  }

  TextSpan _buildTextSpan(
    String text,
    List<Entity> entities,
    BuildContext context,
  ) {
    final List<TextSpan> spans = [];
    int entityIndex = 0;
    int textIndex = 0;

    while (textIndex < text.length) {
      if (textIndex < text.length &&
          text[textIndex] == '{' &&
          textIndex + 1 < text.length &&
          text[textIndex + 1] == '}') {
        // Found placeholder {}
        if (entityIndex < entities.length) {
          final entity = entities[entityIndex];
          spans.add(_buildEntitySpan(entity, context));
          entityIndex++;
        }
        textIndex += 2; // Skip {}
      } else {
        // Regular text
        final nextPlaceholder = text.indexOf('{}', textIndex);
        final endIndex = nextPlaceholder == -1 ? text.length : nextPlaceholder;
        final regularText = text.substring(textIndex, endIndex);
        spans.add(TextSpan(text: regularText, style: baseStyle));
        textIndex = endIndex;
      }
    }

    return TextSpan(children: spans);
  }

  TextSpan _buildEntitySpan(Entity entity, BuildContext context) {
    final color =
        entity.color != null
            ? Color(int.parse(entity.color!.replaceFirst('#', '0xFF')))
            : null;
    final fontSize = entity.fontSize?.toDouble();
    final fontStyle =
        entity.fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal;
    final decoration =
        entity.fontStyle == 'underline'
            ? TextDecoration.underline
            : TextDecoration.none;

    return TextSpan(
      text: entity.text ?? '',
      style: (baseStyle ?? const TextStyle()).copyWith(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        decoration: decoration,
        fontWeight:
            entity.fontFamily?.contains('semi_bold') == true
                ? FontWeight.w600
                : FontWeight.normal,
      ),
      recognizer:
          entity.text != null && entity.text!.isNotEmpty
              ? (TapGestureRecognizer()
                ..onTap = () => _handleEntityTap(entity, context))
              : null,
    );
  }

  void _handleEntityTap(Entity entity, BuildContext context) {
    if (entity.text != null && entity.text!.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tapped: ${entity.text}')));
    }
  }
}
