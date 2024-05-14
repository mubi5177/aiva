import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      child: FlutterSwitch(
          toggleSize: 22.0,
          height: 28.0,
          activeColor: context.secondary,
          toggleColor: context.onPrimary,
          inactiveToggleColor: context.onPrimary,
          inactiveColor: context.tertiary,
          borderRadius: 36.0,
          value: value,
          onToggle: onChanged),
    );
  }
}
