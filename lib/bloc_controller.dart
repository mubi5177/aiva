import 'package:aivi/cubit/action_cubit.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/cubit/expansion_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocController extends StatelessWidget {
  final Widget child;

  const BlocController({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DrawerCubit()),
        BlocProvider(create: (_) => ExpansionCubit()),
      ],
      child: child,
    );
  }
}
