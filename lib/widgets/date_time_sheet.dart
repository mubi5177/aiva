
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/extensions/e_date_time.dart';
import 'package:aivi/cubit/date_time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class EndDateTimeSheet extends StatefulWidget {
  const EndDateTimeSheet({required this.dateTimeCubit});

  final DateTimeCubit dateTimeCubit;

  @override
  State<EndDateTimeSheet> createState() => EndDateTimeSheetState();
}

class EndDateTimeSheetState extends State<EndDateTimeSheet> {
  DateTime _today = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateTimeCubit, String>(
      bloc: widget.dateTimeCubit,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text("End Date", style: context.displayMedium),
            ),
            TableCalendar(
              focusedDay: _today,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 3, 14),
              rowHeight: 40.0,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left, color: context.primary),
                rightChevronIcon: Icon(Icons.chevron_right, color: context.primary),
              ),
              formatAnimationDuration: const Duration(milliseconds: 500),
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableGestures: AvailableGestures.all,
              onDaySelected: (day, time) {
                setState(() {
                  _today = time;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: context.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: context.primary.withOpacity(.5),
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) => isSameDay(_today, day),
            ),
            const Divider(indent: 16.0, endIndent: 16.0),
            const Gap(20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("To", style: context.titleSmall),
            ),
            const Gap(10.0),
            ListTile(
              leading: Text(
                _today.day.toString(),
                style: context.displaySmall!.copyWith(fontSize: 48.0),
              ),
              title: Text('${_today.formatTime()} ${_today.year}', style: context.displaySmall),
              subtitle: Text(
                _today.formatTime(format: 'EEEE'),
                style: context.displaySmall?.copyWith(color: context.tertiary),
              ),

            ),
            const Gap(40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AppButton(
                height: 50.0,
                onPressed: () {
                  DateTime date1 = _selectedTime;
                  DateTime date2 = _today;
                  DateTime mergedDate = _mergeEndDate(date1, date2);
                  widget.dateTimeCubit.update(mergedDate);
                  context.pop();
                },
                child: const Text("Done"),
              ),
            ),
            const Gap(20.0),
          ],
        );
      },
    );
  }
}

DateTime _mergeEndDate(DateTime date1, DateTime date2) {
  // Replace the time components of date2 with those of date1
  DateTime mergedDate = DateTime(
    date2.year,
    date2.month,
    date2.day,
    date1.hour,
    date1.minute,
    date1.second,
    date1.millisecond,
    date1.microsecond,
  );
  return mergedDate;
}
