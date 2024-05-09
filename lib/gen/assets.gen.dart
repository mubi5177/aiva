/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Google.png
  AssetGenImage get google => const AssetGenImage('assets/images/Google.png');

  /// File path: assets/images/aiva_mic.png
  AssetGenImage get aivaMic =>
      const AssetGenImage('assets/images/aiva_mic.png');

  /// File path: assets/images/apple.png
  AssetGenImage get apple => const AssetGenImage('assets/images/apple.png');

  /// File path: assets/images/avia_logo.png
  AssetGenImage get aviaLogo =>
      const AssetGenImage('assets/images/avia_logo.png');

  /// File path: assets/images/fb.png
  AssetGenImage get fb => const AssetGenImage('assets/images/fb.png');

  /// File path: assets/images/no_habbit_icon.png
  AssetGenImage get noHabbitIcon =>
      const AssetGenImage('assets/images/no_habbit_icon.png');

  /// File path: assets/images/no_task_icon.png
  AssetGenImage get noTaskIcon =>
      const AssetGenImage('assets/images/no_task_icon.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [google, aivaMic, apple, aviaLogo, fb, noHabbitIcon, noTaskIcon];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/about.svg
  String get about => 'assets/svgs/about.svg';

  /// File path: assets/svgs/back.svg
  String get back => 'assets/svgs/back.svg';

  /// File path: assets/svgs/cycle.svg
  String get cycle => 'assets/svgs/cycle.svg';

  /// File path: assets/svgs/delete.svg
  String get delete => 'assets/svgs/delete.svg';

  /// File path: assets/svgs/drawer.svg
  String get drawer => 'assets/svgs/drawer.svg';

  /// File path: assets/svgs/labels.svg
  String get labels => 'assets/svgs/labels.svg';

  /// File path: assets/svgs/logout.svg
  String get logout => 'assets/svgs/logout.svg';

  /// File path: assets/svgs/notes.svg
  String get notes => 'assets/svgs/notes.svg';

  /// File path: assets/svgs/notification.svg
  String get notification => 'assets/svgs/notification.svg';

  /// File path: assets/svgs/notificatons.svg
  String get notificatons => 'assets/svgs/notificatons.svg';

  /// File path: assets/svgs/profile.svg
  String get profile => 'assets/svgs/profile.svg';

  /// File path: assets/svgs/search.svg
  String get search => 'assets/svgs/search.svg';

  /// File path: assets/svgs/upload.svg
  String get upload => 'assets/svgs/upload.svg';

  /// List of all assets
  List<String> get values => [
        about,
        back,
        cycle,
        delete,
        drawer,
        labels,
        logout,
        notes,
        notification,
        notificatons,
        profile,
        search,
        upload
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
