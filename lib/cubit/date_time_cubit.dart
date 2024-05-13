import 'package:aivi/core/extensions/e_date_time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateTimeCubit extends Cubit<String> {
  DateTimeCubit() : super('');

  void update(DateTime dateTime) {
    emit(dateTime.formatDateTime(format: 'MM/dd/yyyy hh:mm a'));
  }
}

class DateTimeCubit2 extends Cubit<DateTime> {
  DateTimeCubit2() : super(DateTime.now());

  void update(DateTime dateTime) {
    emit(dateTime);
  }
}
