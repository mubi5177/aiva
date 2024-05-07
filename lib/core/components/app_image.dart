import 'dart:io';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AppImage extends StatelessWidget {
  final Widget _child;

  AppImage.network({
    super.key,
    required final String imageUrl,
    final Map<String, String>? httpHeaders,
    final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
    final Widget Function(BuildContext, String)? placeholder,
    final Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder,
    final Widget Function(BuildContext, String, dynamic)? errorWidget,
    final Duration? fadeOutDuration,
    final Curve? fadeOutCurve,
    final Duration? fadeInDuration,
    final Curve? fadeInCurve,
    final double? width,
    final double? height,
    final BoxFit? fit,
    final AlignmentGeometry? alignment,
    final ImageRepeat? repeat,
    final bool? matchTextDirection,
    final bool? useOldImageOnUrlChange,
    final Color? color,
    final FilterQuality? filterQuality,
    final BlendMode? colorBlendMode,
    final Duration? placeholderFadeInDuration,
    final int? memCacheWidth,
    final int? memCacheHeight,
    final String? cacheKey,
    final int? maxWidthDiskCache,
    final int? maxHeightDiskCache,
    final BorderRadius? borderRadius,
    final bool isAnonymous = false,
    final double? anonymousSize,
  }) : _child = _NetworkImage(
          imageUrl: imageUrl,
          httpHeaders: httpHeaders,
          imageBuilder: imageBuilder,
          placeholder: placeholder,
          progressIndicatorBuilder: progressIndicatorBuilder,
          errorWidget: errorWidget,
          fadeOutDuration: fadeOutDuration,
          fadeOutCurve: fadeOutCurve,
          fadeInDuration: fadeInDuration,
          fadeInCurve: fadeInCurve,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          useOldImageOnUrlChange: useOldImageOnUrlChange,
          color: color,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
          placeholderFadeInDuration: placeholderFadeInDuration,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          cacheKey: cacheKey,
          maxWidthDiskCache: maxWidthDiskCache,
          maxHeightDiskCache: maxHeightDiskCache,
          borderRadius: borderRadius,
          isAnonymous: isAnonymous,
          anonymousSize: anonymousSize,
        );

  AppImage.file({
    super.key,
    required File file,
    final double? width,
    final double? height,
    final Color? color,
    final BoxFit? fit,
    final BorderRadius? borderRadius,
  }) : _child = _ImageFile(
          file: file,
          width: width,
          height: height,
          color: color,
          fit: fit,
          borderRadius: borderRadius,
        );

  AppImage.svg({
    super.key,
    required final String assetName,
    final Color? color,
    final double? size,
    final BoxFit? fit,
  }) : _child = _SvgImage(assetName: assetName, color: color, size: size, fit: fit);

  AppImage.assets({
    super.key,
    required final String assetName,
    final Color? color,
    final double? height,
    final double? width,
    final BoxFit? fit,
    final BorderRadiusGeometry? borderRadius,
  }) : _child = _Assets(
          assetName: assetName,
          color: color,
          height: height,
          width: width,
          fit: fit,
          borderRadius: borderRadius,
        );

  AppImage.empty({
    super.key,
    final Widget? child,
  }) : _child = _Empty(child: child);

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

class _NetworkImage extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Duration fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final Duration? placeholderFadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final BorderRadius? borderRadius;
  final bool isAnonymous;
  final double? anonymousSize;

  const _NetworkImage({
    required this.imageUrl,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    final Duration? fadeOutDuration,
    final Curve? fadeOutCurve,
    final Duration? fadeInDuration,
    final Curve? fadeInCurve,
    this.width,
    this.height,
    this.fit,
    final AlignmentGeometry? alignment,
    final ImageRepeat? repeat,
    final bool? matchTextDirection,
    final bool? useOldImageOnUrlChange,
    this.color,
    final FilterQuality? filterQuality,
    final BorderRadius? borderRadius,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.isAnonymous = false,
    this.anonymousSize = 26.0,
  })  : fadeOutDuration = fadeOutDuration ?? const Duration(milliseconds: 1000),
        fadeOutCurve = fadeOutCurve ?? Curves.easeOut,
        fadeInDuration = fadeInDuration ?? const Duration(milliseconds: 500),
        fadeInCurve = fadeInCurve ?? Curves.easeIn,
        alignment = alignment ?? Alignment.center,
        repeat = repeat ?? ImageRepeat.noRepeat,
        matchTextDirection = matchTextDirection ?? false,
        useOldImageOnUrlChange = useOldImageOnUrlChange ?? false,
        filterQuality = filterQuality ?? FilterQuality.low,
        borderRadius = borderRadius ?? BorderRadius.zero;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return placeholder?.call(context, imageUrl) ?? const SizedBox();
    }
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          color: color,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
        ),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        httpHeaders: httpHeaders,
        placeholder: placeholder,
        progressIndicatorBuilder: progressIndicatorBuilder,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        maxWidthDiskCache: maxWidthDiskCache,
        matchTextDirection: matchTextDirection,
        width: width,
        errorWidget: errorWidget,
        maxHeightDiskCache: maxHeightDiskCache,
        placeholderFadeInDuration: placeholderFadeInDuration,
        fadeInCurve: fadeInCurve,
        fadeOutCurve: fadeOutCurve,
        filterQuality: filterQuality,
        fit: fit,
        height: height,
        memCacheWidth: memCacheWidth,
        repeat: repeat,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        imageBuilder: imageBuilder,
        memCacheHeight: memCacheHeight,
        key: key,
        cacheKey: cacheKey,
        color: color,
        colorBlendMode: colorBlendMode,
      ),
    );
  }
}

class _ImageFile extends StatelessWidget {
  final File file;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const _ImageFile({
    required this.file,
    this.width,
    this.height,
    this.color,
    this.fit,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          file.path,
          width: width,
          height: height,
          color: color,
          fit: fit,
        ),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        file,
        width: width,
        height: height,
        color: color,
        fit: fit,
      ),
    );
  }
}

class _SvgImage extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double? size;
  final BoxFit? fit;

  const _SvgImage({required this.assetName, this.color, this.size, this.fit});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(color ?? context.primary, BlendMode.srcIn),
      height: size,
      width: size,
      fit: fit ?? BoxFit.contain,
    );
  }
}

class _Assets extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;

  const _Assets({required this.assetName, this.color, this.height, this.width, this.fit, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(assetName, color: color, height: height, width: width, fit: fit),
    );
  }
}

class _Empty extends StatelessWidget {
  final Widget? child;

  const _Empty({this.child});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundColor: context.primary.withOpacity(.1), child: child);
  }
}
