import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:flutter/material.dart';

const double _defaultButtonHeight = 36.0;

class AppButton extends StatelessWidget {
  final Widget _child;

  AppButton({
    super.key,
    final double? height,
    final double? width,
    final double? elevation,
    required final Widget child,
    final Color? background,
    final Color? foregroundColor,
    final VoidCallback? onPressed,
    final bool? isProcessing,
    final BoxConstraints? constraints,
    final BorderRadius? borderRadius,
  }) : _child = _ElevatedButton(
          height: height,
          width: width,
          elevation: elevation,
          background: background,
          foregroundColor: foregroundColor,
          onPressed: onPressed,
          isProcessing: isProcessing ?? false,
          constraints: constraints,
          borderRadius: borderRadius,
          child: child,
        );

  AppButton.icon({
    super.key,
    required final VoidCallback onTap,
    required final Widget child,
    final EdgeInsetsGeometry? margin,
    final BoxDecoration? decoration,
    final Color? imageColor,
    final double? height,
    final double? width,
  }) : _child = _IconButton(height: height, width: width, imageColor: imageColor, decoration: decoration, onTap: onTap, margin: margin, child: child);

  AppButton.primary({
    super.key,
    final double? height,
    final double? width,
    final double? elevation,
    required final Widget child,
    final Color? background,
    final Color? foregroundColor,
    final Color? fore,
    final VoidCallback? onPressed,
    final bool? isProcessing,
    final BoxConstraints? constraints,
    final BorderRadius? borderRadius,
  }) : _child = _PrimaryButton(
          height: height,
          width: width,
          elevation: elevation,
          background: background,
          foregroundColor: foregroundColor,
          onPressed: onPressed,
          isProcessing: isProcessing ?? false,
          constraints: constraints,
          borderRadius: borderRadius,
          child: child,
        );

  AppButton.socialIcon({
    super.key,
    final VoidCallback? onPressed,
    required final Widget child,
    final double? height,
    final double? width,
  }) : _child = _SocialIconButton(
          onPressed: onPressed,
          height: height,
          width: width,
          child: child,
        );

  AppButton.outline({
    super.key,
    final double? height,
    final double? width,
    final double? elevation,
    required final Widget child,
    final Color? background,
    final Color? borderColor,
    final VoidCallback? onPressed,
    final bool? isProcessing,
    final EdgeInsets? padding,
    final BoxConstraints? constraints,
  }) : _child = _OutlineButton(
          height: height,
          width: width,
          padding: padding,
          elevation: elevation,
          background: background,
          borderColor: borderColor,
          onPressed: onPressed,
          isProcessing: isProcessing ?? false,
          constraints: constraints,
          child: child,
        );

  AppButton.smallButton({
    super.key,
    final String title = '',
    final VoidCallback? onTap,
  }) : _child = _SmallButton(title: title, onTap: onTap);

  AppButton.borderIcon({
    super.key,
    required final Widget icon,
    final VoidCallback? onTap,
    final Color? background,
    final Color? borderColor,
    final double? size,
  }) : _child = _BorderIconButton(
          icon: icon,
          onTap: onTap,
          background: background,
          borderColor: borderColor,
          size: size,
        );

  AppButton.shrink({
    super.key,
    final double? height,
    final double? elevation,
    final double? width,
    required final Widget child,
    final Color? background,
    final VoidCallback? onPressed,
    final BorderRadius? borderRadius,
    final bool? isProcessing,
  }) : _child = _ShrinkElevatedButton(
          elevation: elevation,
          height: height,
          width: width,
          background: background,
          onPressed: onPressed,
          borderRadius: borderRadius,
          isProcessing: isProcessing ?? false,
          child: child,
        );

  AppButton.shrinkTab({
    super.key,
    final double? height,
    final double? elevation,
    final double? width,
    final Color? activeTabColor,
    final Color? inActiveTabColor,
    final VoidCallback? onPressed,
    final bool? isActive,
    required final String label,
    final TextStyle? labelStyle,
    final EdgeInsets? margin,
  }) : _child = _ShrinkTab(
          height: height,
          width: width,
          isActive: isActive,
          onPressed: onPressed,
          activeTabColor: activeTabColor,
          inActiveTabColor: inActiveTabColor,
          label: label,
          labelStyle: labelStyle,
          margin: margin,
        );

  AppButton.outlineShrink({
    super.key,
    final double? height,
    final double? elevation,
    final double? width,
    required final Widget child,
    final Color? background,
    final Color? borderColor,
    final VoidCallback? onPressed,
    final bool? isProcessing,
  }) : _child = _ShrinkOutlineButton(
          elevation: elevation,
          height: height,
          width: width,
          background: background,
          borderColor: borderColor,
          onPressed: onPressed,
          isProcessing: isProcessing ?? false,
          child: child,
        );

  AppButton.appbar({
    super.key,
    final double? height,
    final double? elevation,
    final double? width,
    required final Widget child,
    final Color? background,
    final VoidCallback? onPressed,
    final bool? isProcessing,

    /// count default value is -1 and pass any value greater than 0 to show badge
    final int? count,
  }) : _child = _AppElevatedButton(
          elevation: elevation,
          height: height,
          width: width,
          background: background,
          onPressed: onPressed,
          isProcessing: isProcessing,
          count: count,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

class _ElevatedButton extends StatelessWidget {
  final double height, width;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool isProcessing;
  final Color? background;
  final Color? foregroundColor;
  final Widget child;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;

  const _ElevatedButton({
    final double? height,
    final double? width,
    this.elevation,
    this.onPressed,
    this.background,
    this.foregroundColor,
    this.constraints,
    this.borderRadius,
    this.isProcessing = false,
    required this.child,
  })  : width = width ?? double.infinity,
        height = height ?? _defaultButtonHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: background == null ? null : MaterialStateProperty.all<Color>(background!),
          foregroundColor: foregroundColor == null ? null : MaterialStateProperty.all<Color>(foregroundColor!),
          minimumSize: MaterialStateProperty.all<Size>(Size(width, _defaultButtonHeight)),
          shape: borderRadius == null
              ? null
              : MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius!),
                ),
        ),
        onPressed: () {
          if (isProcessing) return;
          if (onPressed != null) onPressed!();
        },
        child: isProcessing ? _CircularProgressIndicator(height: height * 0.7, color: Theme.of(context).colorScheme.onPrimary) : child,
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final double height, width;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool isProcessing;
  final Color? background;
  final Color? borderColor;
  final Widget child;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;

  const _OutlineButton({
    final double? height,
    final double? width,
    this.elevation,
    this.onPressed,
    this.background,
    this.borderColor,
    this.constraints,
    this.isProcessing = false,
    this.padding,
    required this.child,
  })  : height = height ?? _defaultButtonHeight,
        width = width ?? double.infinity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      child: OutlinedButton(
        style: ButtonStyle(
          side: borderColor == null ? null : MaterialStateProperty.all(BorderSide(color: borderColor!)),
          padding: padding == null ? null : MaterialStateProperty.all(padding),
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: background == null ? null : MaterialStateProperty.all<Color>(background!),
        ),
        onPressed: onPressed,
        child: isProcessing ? _CircularProgressIndicator(height: height * 0.7, color: context.onPrimary) : child,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final double height, width;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool isProcessing;
  final Color? background;
  final Color? foregroundColor;
  final Widget child;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;

  const _PrimaryButton({
    final double? height,
    final double? width,
    this.elevation,
    this.onPressed,
    this.background,
    this.constraints,
    this.isProcessing = false,
    this.borderRadius,
    this.foregroundColor,
    required this.child,
  })  : height = height ?? _defaultButtonHeight,
        width = width ?? double.infinity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: borderRadius == null
              ? null
              : MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius!),
                ),
          elevation: MaterialStateProperty.all(elevation),
          minimumSize: MaterialStateProperty.all<Size>(Size(width, _defaultButtonHeight)),
          backgroundColor: background == null ? MaterialStateProperty.all<Color>(context.primary) : MaterialStateProperty.all<Color>(background!),
          foregroundColor:
              foregroundColor == null ? MaterialStateProperty.all<Color>(context.onPrimary) : MaterialStateProperty.all<Color>(foregroundColor!),
        ),
        onPressed: () {
          if (isProcessing) return;
          if (onPressed != null) onPressed!();
        },
        child: isProcessing ? _CircularProgressIndicator(height: height * 0.7, color: Theme.of(context).colorScheme.onPrimary) : child,
      ),
    );
  }
}

class _ShrinkTab extends StatelessWidget {
  final double height;
  final double? width;
  final VoidCallback? onPressed;
  final Color? activeTabColor;
  final Color? inActiveTabColor;
  final String label;
  final TextStyle? labelStyle;
  final bool isActive;
  final EdgeInsets margin;

  const _ShrinkTab({
    final double? height,
    this.width,
    this.onPressed,
    this.activeTabColor,
    this.inActiveTabColor,
    this.labelStyle,
    bool? isActive,
    final EdgeInsets? margin,
    required this.label,
  })  : isActive = isActive ?? false,
        height = height ?? _defaultButtonHeight,
        margin = margin ?? const EdgeInsets.symmetric(horizontal: 8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: null,
        height: height,
        child: Padding(
          padding: margin,
          child: Material(
            color: Colors.transparent,
            shape: Border(
              bottom: BorderSide(
                width: 3.0,
                color: isActive ? activeTabColor ?? context.primary : inActiveTabColor ?? context.lightGrey.withOpacity(0.6),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: labelStyle ??
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.43,
                          fontWeight: FontWeight.w600,
                          color: isActive ? activeTabColor ?? context.primary : inActiveTabColor ?? context.lightGrey,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShrinkElevatedButton extends StatelessWidget {
  final double height;
  final double? width;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool isProcessing;
  final Color? background;
  final Widget child;
  final BorderRadius? borderRadius;

  const _ShrinkElevatedButton({
    final double? height,
    this.elevation,
    this.width,
    this.onPressed,
    this.background,
    this.borderRadius,
    required this.isProcessing,
    required this.child,
  }) : height = height ?? _defaultButtonHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(width ?? double.infinity, _defaultButtonHeight)),
          foregroundColor: MaterialStateProperty.all<Color>(context.onPrimary),
          shape: borderRadius == null ? null : MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: borderRadius!)),
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: background == null ? null : MaterialStateProperty.all<Color>(background!),
        ),
        onPressed: onPressed,
        child: isProcessing ? _CircularProgressIndicator(height: height * 0.7) : child,
      ),
    );
  }
}

class _ShrinkOutlineButton extends StatelessWidget {
  final double height;
  final double? width;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool isProcessing;
  final Color? background;
  final Color? borderColor;
  final Widget child;

  const _ShrinkOutlineButton({
    final double? height,
    this.elevation,
    this.width,
    this.onPressed,
    this.background,
    this.isProcessing = false,
    this.borderColor,
    required this.child,
  }) : height = height ?? _defaultButtonHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(width ?? double.infinity, _defaultButtonHeight)),
          side: borderColor == null ? null : MaterialStateProperty.all(BorderSide(color: borderColor!)),
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: background == null ? null : MaterialStateProperty.all<Color>(background!),
        ),
        onPressed: onPressed,
        child: isProcessing ? _CircularProgressIndicator(height: height * 0.7, color: context.onPrimary) : child,
      ),
    );
  }
}

class _AppElevatedButton extends StatelessWidget {
  final double height;
  final double? width;
  final double? elevation;
  final VoidCallback? onPressed;
  final bool? isProcessing;
  final Color? background;
  final Widget child;
  final int count;

  const _AppElevatedButton({
    final double? height,
    final int? count,
    this.elevation,
    this.width,
    this.onPressed,
    this.background,
    this.isProcessing = false,
    required this.child,
  })  : height = height ?? _defaultButtonHeight,
        count = count ?? -1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: null,
          height: height,
          decoration: BoxDecoration(
            border: Border.symmetric(vertical: BorderSide(color: Theme.of(context).primaryColorDark)),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(elevation),
              backgroundColor: background == null ? null : MaterialStateProperty.all<Color>(background!),
            ),
            onPressed: onPressed,
            child: child,
          ),
        ),
        if (count > 0)
          Positioned(
            right: 8.0,
            top: 6.0,
            child: Container(
              constraints: const BoxConstraints(minWidth: 18.0, minHeight: 18.0, maxWidth: 18.0, maxHeight: 18.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: context.primaryColorDark, borderRadius: BorderRadius.circular(10.0)),
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                child: Text(
                  '${count > 9 ? '9+' : count}',
                  style: context.bodySmall?.copyWith(fontSize: 8.0, color: context.onPrimary, fontWeight: FontWeight.bold, height: 0.0),
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? height, width;

  const _SocialIconButton({
    this.onPressed,
    final double? height,
    final double? width,
    required this.child,
  })  : height = height ?? 44.0,
        width = width ?? 44.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(
              color: context.lightGrey.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12)),
        child: child,
      ),
    );
  }
}

class _CircularProgressIndicator extends StatelessWidget {
  final double height;
  final Color? color;

  const _CircularProgressIndicator({required this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.7,
      width: height * 0.7,
      child: CircularProgressIndicator(strokeWidth: 4, color: color ?? context.onPrimary),
    );
  }
}

class _BorderIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final Color? background;
  final Color? borderColor;
  final double size;

  const _BorderIconButton({
    required this.icon,
    this.onTap,
    this.background,
    this.borderColor,
    final double? size,
  }) : size = size ?? 44.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: borderColor ?? context.lightGrey.withOpacity(0.2)),
          ),
          child: icon,
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Color? imageColor;
  final double? height;
  final double? width;

  const _IconButton({
    required this.onTap,
    this.height,
    this.width,
    this.imageColor,
    required this.child,
    this.decoration,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.all(4.0),
      decoration: decoration ?? BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onTap,
        icon: child,
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SmallButton({this.title = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.0),
      overlayColor: MaterialStateProperty.all(context.onPrimary.withOpacity(0.1)),
      child: Container(
        width: 74.0,
        height: 30.0,
        decoration: BoxDecoration(color: context.primary, borderRadius: BorderRadius.circular(20.0)),
        child: Center(
          child: Text(
            title,
            style: context.bodyMedium?.copyWith(color: context.onPrimary, fontWeight: FontWeight.w600, fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
