import 'package:aivi/core/components/app_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SocialCustomButton extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onPressed;
  final List<BoxShadow>? boxShadow;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const SocialCustomButton({
    Key? key,
    required this.text,
    this.boxShadow,
    required this.image,
    required this.onPressed,
    required this.color,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 20,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: boxShadow??[
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: .5,
              blurRadius: 20,
              offset: const Offset(1, 1),
            ),
          ],
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(image.isNotEmpty)...{
              AppImage.assets(
                assetName: image,
                height: 30.0,
                width: 30.0,
              ),
              const Gap(12.0),
            },

            Text(
              text,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}