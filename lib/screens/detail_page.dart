import 'package:flutter/material.dart';
import 'package:studize_interview/widgets/date_picker.dart';
import 'package:studize_interview/widgets/task_timeline.dart';
import 'package:studize_interview/widgets/task_title.dart';
import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DateTime selectedDay;

  @override
  void initState() {
    final now = DateTime.now();
    selectedDay = DateTime(
      now.year,
      now.month,
      now.day,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TasksService.getAllTasks(),
      builder: (context, snapshot) {
        final List<Task> taskList = snapshot.data?.toList() ?? [];
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            backgroundColor: Color.fromARGB(255, 23, 23, 23),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          floatingActionButton: const FloatingActionButton.extended(
            onPressed: null,
            label: Text('New Task'),
            icon: Icon(Icons.edit),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DatePicker(
                        callback: (selectedDay) =>
                            setState(() => this.selectedDay = selectedDay),
                      ),
                      const TaskTitle(),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => TaskTimeline(
                    task: taskList[index],
                    subjectColor: taskList[index].color,
                    gradient: taskList[index].gradientColors,
                    isFirst: index == 0,
                    isLast: index == taskList.length - 1,
                    refreshCallback: () {
                      setState(() {});
                    },
                  ),
                  childCount: taskList.length,
                ),
              )
            ],
          ),
          backgroundColor: Color.fromARGB(255, 21, 21, 21),
        );
      },
    );
  }
}
