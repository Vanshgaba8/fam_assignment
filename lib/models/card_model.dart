class CardModel {
  int? id;
  String? slug;
  String? title;
  String? formattedTitle;
  String? description;
  String? formattedDescription;
  dynamic assets;
  List<HcGroups>? hcGroups;

  CardModel({
    this.id,
    this.slug,
    this.title,
    this.formattedTitle,
    this.description,
    this.formattedDescription,
    this.assets,
    this.hcGroups,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    formattedTitle = json['formatted_title'];
    description = json['description'];
    formattedDescription = json['formatted_description'];
    assets = json['assets'];
    if (json['hc_groups'] != null) {
      hcGroups = <HcGroups>[];
      json['hc_groups'].forEach((v) {
        hcGroups!.add(HcGroups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['formatted_title'] = formattedTitle;
    data['description'] = description;
    data['formatted_description'] = formattedDescription;
    data['assets'] = assets;
    if (hcGroups != null) {
      data['hc_groups'] = hcGroups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HcGroups {
  int? id;
  String? name;
  String? designType;
  int? cardType;
  List<Cards>? cards;
  bool? isScrollable;
  int? height;
  bool? isFullWidth;
  String? slug;
  int? level;

  HcGroups({
    this.id,
    this.name,
    this.designType,
    this.cardType,
    this.cards,
    this.isScrollable,
    this.height,
    this.isFullWidth,
    this.slug,
    this.level,
  });

  HcGroups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designType = json['design_type'];
    cardType = json['card_type'];
    if (json['cards'] != null) {
      cards = <Cards>[];
      json['cards'].forEach((v) {
        cards!.add(Cards.fromJson(v));
      });
    }
    isScrollable = json['is_scrollable'];
    height = json['height'];
    isFullWidth = json['is_full_width'];
    slug = json['slug'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['design_type'] = designType;
    data['card_type'] = cardType;
    if (cards != null) {
      data['cards'] = cards!.map((v) => v.toJson()).toList();
    }
    data['is_scrollable'] = isScrollable;
    data['height'] = height;
    data['is_full_width'] = isFullWidth;
    data['slug'] = slug;
    data['level'] = level;
    return data;
  }
}

class Cards {
  int? id;
  String? name;
  String? slug;
  String? title;
  FormattedTitle? formattedTitle;
  List<dynamic>? positionalImages;
  List<dynamic>? components;
  String? url;
  BgImage? bgImage;
  List<Cta>? cta;
  bool? isDisabled;
  bool? isShareable;
  bool? isInternal;
  CardIcon? icon;
  String? bgColor;
  int? iconSize;
  BgGradient? bgGradient;
  String? description;
  FormattedTitle? formattedDescription;

  Cards({
    this.id,
    this.name,
    this.slug,
    this.title,
    this.formattedTitle,
    this.positionalImages,
    this.components,
    this.url,
    this.bgImage,
    this.cta,
    this.isDisabled,
    this.isShareable,
    this.isInternal,
    this.icon,
    this.bgColor,
    this.iconSize,
    this.bgGradient,
    this.description,
    this.formattedDescription,
  });

  Cards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    title = json['title'];
    formattedTitle =
        json['formatted_title'] != null
            ? FormattedTitle.fromJson(json['formatted_title'])
            : null;
    positionalImages = json['positional_images'];
    components = json['components'];
    url = json['url'];
    bgImage =
        json['bg_image'] != null ? BgImage.fromJson(json['bg_image']) : null;
    if (json['cta'] != null) {
      cta = <Cta>[];
      json['cta'].forEach((v) {
        cta!.add(Cta.fromJson(v));
      });
    }
    isDisabled = json['is_disabled'];
    isShareable = json['is_shareable'];
    isInternal = json['is_internal'];
    icon = json['icon'] != null ? CardIcon.fromJson(json['icon']) : null;
    bgColor = json['bg_color'];
    iconSize = json['icon_size'];
    bgGradient =
        json['bg_gradient'] != null
            ? BgGradient.fromJson(json['bg_gradient'])
            : null;
    description = json['description'];
    formattedDescription =
        json['formatted_description'] != null
            ? FormattedTitle.fromJson(json['formatted_description'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['title'] = title;
    if (formattedTitle != null) {
      data['formatted_title'] = formattedTitle!.toJson();
    }
    data['positional_images'] = positionalImages;
    data['components'] = components;
    data['url'] = url;
    if (bgImage != null) {
      data['bg_image'] = bgImage!.toJson();
    }
    if (cta != null) {
      data['cta'] = cta!.map((v) => v.toJson()).toList();
    }
    data['is_disabled'] = isDisabled;
    data['is_shareable'] = isShareable;
    data['is_internal'] = isInternal;
    if (icon != null) {
      data['icon'] = icon!.toJson();
    }
    data['bg_color'] = bgColor;
    data['icon_size'] = iconSize;
    if (bgGradient != null) {
      data['bg_gradient'] = bgGradient!.toJson();
    }
    data['description'] = description;
    if (formattedDescription != null) {
      data['formatted_description'] = formattedDescription!.toJson();
    }
    return data;
  }
}

class FormattedTitle {
  String? text;
  String? align;
  List<Entity>? entities;

  FormattedTitle({this.text, this.align, this.entities});

  FormattedTitle.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    align = json['align'];
    if (json['entities'] != null) {
      entities = <Entity>[];
      json['entities'].forEach((v) {
        entities!.add(Entity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['align'] = align;
    if (entities != null) {
      data['entities'] = entities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entity {
  String? text;
  String? type;
  String? color;
  int? fontSize;
  String? fontStyle;
  String? fontFamily;
  String? url;

  Entity({
    this.text,
    this.type,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.fontFamily,
    this.url,
  });

  Entity.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
    color = json['color'];
    fontSize = json['font_size'];
    fontStyle = json['font_style'];
    fontFamily = json['font_family'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['type'] = type;
    data['color'] = color;
    data['font_size'] = fontSize;
    data['font_style'] = fontStyle;
    data['font_family'] = fontFamily;
    data['url'] = url;
    return data;
  }
}

class BgImage {
  String? imageType;
  String? imageUrl;
  double? aspectRatio;

  BgImage({this.imageType, this.imageUrl, this.aspectRatio});

  BgImage.fromJson(Map<String, dynamic> json) {
    imageType = json['image_type'];
    imageUrl = json['image_url'];
    aspectRatio = (json['aspect_ratio'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['image_type'] = imageType;
    data['image_url'] = imageUrl;
    data['aspect_ratio'] = aspectRatio;
    return data;
  }
}

class Cta {
  String? text;
  String? type;
  String? bgColor;
  bool? isCircular;
  bool? isSecondary;
  int? strokeWidth;

  Cta({
    this.text,
    this.type,
    this.bgColor,
    this.isCircular,
    this.isSecondary,
    this.strokeWidth,
  });

  Cta.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
    bgColor = json['bg_color'];
    isCircular = json['is_circular'];
    isSecondary = json['is_secondary'];
    strokeWidth = json['stroke_width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['type'] = type;
    data['bg_color'] = bgColor;
    data['is_circular'] = isCircular;
    data['is_secondary'] = isSecondary;
    data['stroke_width'] = strokeWidth;
    return data;
  }
}

class CardIcon {
  String? imageType;
  String? imageUrl;
  int? aspectRatio;

  CardIcon({this.imageType, this.imageUrl, this.aspectRatio});

  CardIcon.fromJson(Map<String, dynamic> json) {
    imageType = json['image_type'];
    imageUrl = json['image_url'];
    aspectRatio = json['aspect_ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['image_type'] = imageType;
    data['image_url'] = imageUrl;
    data['aspect_ratio'] = aspectRatio;
    return data;
  }
}

class BgGradient {
  int? angle;
  List<String>? colors;

  BgGradient({this.angle, this.colors});

  BgGradient.fromJson(Map<String, dynamic> json) {
    angle = json['angle'];
    colors = (json['colors'] as List?)?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['angle'] = angle;
    data['colors'] = colors;
    return data;
  }
}
