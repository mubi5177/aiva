import 'package:flutter_bloc/flutter_bloc.dart';

class ActionCubit extends Cubit<String> {
  // Accepts an initial action which can be dynamic.
  ActionCubit(super.initialAction);



  void onChanged(String action) => emit(action);
}
