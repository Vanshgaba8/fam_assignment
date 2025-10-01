import 'package:flutter/material.dart';
import 'package:fam_assignment/models/card_model.dart';

/*
Kindly note that as per rules, the text was to be shown only when curly brackets are present, hence i avoided that.
However, if the text is to be shown, then i have commented out that code in bottom too.
*/

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
    if (formattedTitle == null) {
      return Text(fallbackText ?? '', style: baseStyle, textAlign: textAlign);
    }

    final text = formattedTitle!.text ?? '';
    final entities = formattedTitle!.entities ?? [];

    if (!text.contains('{}')) {
      final displayText = text.trim().isNotEmpty ? text : (fallbackText ?? '');
      return Text(displayText, style: baseStyle, textAlign: textAlign);
    }

    if (entities.isNotEmpty && text.contains('{}')) {
      return RichText(
        textAlign: textAlign ?? TextAlign.left,
        text: _buildTextSpan(text, entities),
      );
    }

    final displayText = text.trim().isNotEmpty ? text : (fallbackText ?? '');
    return Text(displayText, style: baseStyle, textAlign: textAlign);
  }

  TextSpan _buildTextSpan(String text, List<Entity> entities) {
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
          spans.add(_buildEntitySpan(entity));
          entityIndex++;
        }
        textIndex += 2; // Skip {}
      } else {
        // Regular text
        final nextPlaceholder = text.indexOf('{}', textIndex);
        final endIndex = nextPlaceholder == -1 ? text.length : nextPlaceholder;
        final regularText = text.substring(textIndex, endIndex);
        if (regularText.isNotEmpty) {
          spans.add(TextSpan(text: regularText, style: baseStyle));
        }
        textIndex = endIndex;
      }
    }

    return TextSpan(children: spans);
  }

  TextSpan _buildEntitySpan(Entity entity) {
    final color =
        entity.color != null
            ? Color(int.parse(entity.color!.replaceFirst('#', '0xFF')))
            : null;
    final fontSize = entity.fontSize?.toDouble() ?? 14.0;
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:fam_assignment/models/card_model.dart';
//
// class FormattedTextWidget extends StatelessWidget {
//   final FormattedTitle? formattedTitle;
//   final String? fallbackText;
//   final TextStyle? baseStyle;
//   final TextAlign? textAlign;
//
//   const FormattedTextWidget({
//     super.key,
//     this.formattedTitle,
//     this.fallbackText,
//     this.baseStyle,
//     this.textAlign,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (formattedTitle == null) {
//       return Text(fallbackText ?? '', style: baseStyle, textAlign: textAlign);
//     }
//
//     final text = formattedTitle!.text ?? '';
//     final entities = formattedTitle!.entities ?? [];
//
//     if (entities.isNotEmpty && text.trim().isEmpty) {
//       return RichText(
//         textAlign: textAlign ?? TextAlign.left,
//         text: TextSpan(
//           children: entities.map((entity) => _buildEntitySpan(entity)).toList(),
//         ),
//       );
//     }
//
//     if (entities.isNotEmpty && text.contains('{}')) {
//       return RichText(
//         textAlign: textAlign ?? TextAlign.left,
//         text: _buildTextSpan(text, entities),
//       );
//     }
//
//     if (text.trim().isNotEmpty) {
//       return Text(text, style: baseStyle, textAlign: textAlign);
//     }
//
//     // Fallback to fallback text
//     return Text(fallbackText ?? '', style: baseStyle, textAlign: textAlign);
//   }
//
//   TextSpan _buildTextSpan(String text, List<Entity> entities) {
//     final List<TextSpan> spans = [];
//     int entityIndex = 0;
//     int textIndex = 0;
//
//     while (textIndex < text.length) {
//       if (textIndex < text.length &&
//           text[textIndex] == '{' &&
//           textIndex + 1 < text.length &&
//           text[textIndex + 1] == '}') {
//         // Found placeholder {}
//         if (entityIndex < entities.length) {
//           final entity = entities[entityIndex];
//           spans.add(_buildEntitySpan(entity));
//           entityIndex++;
//         }
//         textIndex += 2; // Skip {}
//       } else {
//         // Regular text
//         final nextPlaceholder = text.indexOf('{}', textIndex);
//         final endIndex = nextPlaceholder == -1 ? text.length : nextPlaceholder;
//         final regularText = text.substring(textIndex, endIndex);
//         if (regularText.isNotEmpty) {
//           spans.add(TextSpan(text: regularText, style: baseStyle));
//         }
//         textIndex = endIndex;
//       }
//     }
//
//     return TextSpan(children: spans);
//   }
//
//   TextSpan _buildEntitySpan(Entity entity) {
//     final color =
//     entity.color != null
//         ? Color(int.parse(entity.color!.replaceFirst('#', '0xFF')))
//         : null;
//     final fontSize = entity.fontSize?.toDouble() ?? 14.0;
//     final fontStyle =
//     entity.fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal;
//     final decoration =
//     entity.fontStyle == 'underline'
//         ? TextDecoration.underline
//         : TextDecoration.none;
//
//     return TextSpan(
//       text: entity.text ?? '',
//       style: (baseStyle ?? const TextStyle()).copyWith(
//         color: color,
//         fontSize: fontSize,
//         fontStyle: fontStyle,
//         decoration: decoration,
//         fontWeight:
//         entity.fontFamily?.contains('semi_bold') == true
//             ? FontWeight.w600
//             : FontWeight.normal,
//       ),
//     );
//   }
// }
