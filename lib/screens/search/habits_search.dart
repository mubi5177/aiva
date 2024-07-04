import 'package:aivi/screens/daily_habits/daily_habits.dart';
import 'package:aivi/screens/search/ssearch_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitsSearchTasks extends StatelessWidget {
  final List<dynamic> data;

  const HabitsSearchTasks({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print('SearchTasks.build: $data');
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: data.isEmpty
              ? const SearchEmptyScreen(screen: "Task/Appointments")
              : ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  // itemCount: habitsItemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dataS = data[index];
                    final docId = data[index]['id'];
                    return YourHabits(
                      data: dataS,
                      docId: docId,
                    );
                  },
                )),
    );
  }
}
