import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studize_interview/screens/detail_page.dart';
import 'package:studize_interview/services/tasks/tasks_classes.dart';
import 'package:studize_interview/services/tasks/tasks_service.dart';
import 'package:studize_interview/widgets/task_timeline.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  late DateTime selectedDay;
  late Future<List<Subject>> _subjectListFuture;

  @override
  void initState() {
    super.initState();
    _subjectListFuture = TasksService.getSubjectList();
    final now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day);
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 15));
    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TasksService.getAllTasks(),
      builder: (context, snapshot) {
        final List<Task> taskList = snapshot.data?.toList() ?? [];
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddSubjectDialog(context); // Add your onPressed code here!
            },
            backgroundColor: Color.fromARGB(255, 229, 187, 255),
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/icons/picon.png', // Replace with your image asset path
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover, // Adjust fit as needed
                      ),
                    ),
                    Text(
                      'Hi, Aman!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 82, 0, 137)
                ], // Replace with your desired colors
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1, // Adjust flex to give more space to this section
                    child: Container(
                      decoration: BoxDecoration(
                        // Set background color here
                        borderRadius: BorderRadius.circular(
                            15.0), // Set border radius here
                      ),
                      child: ClipRRect(
                        // ClipRRect to clip the child's overflow
                        borderRadius: BorderRadius.circular(
                            15.0), // Same as container border radius
                        child: FutureBuilder(
                          future: _subjectListFuture,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Subject>> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                List<Subject> subjectList = snapshot.data!;
                                return ListView.builder(
                                  scrollDirection: Axis
                                      .horizontal, // Set scroll direction to horizontal
                                  shrinkWrap: true,
                                  itemCount: subjectList.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 12.0, 0.0, 30.0),
                                    child: _buildSubject(
                                        context, subjectList[index]),
                                  ),
                                );
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                return const Center(
                                  child: Text(
                                      'Fetching subjects from storage....'),
                                );
                              case ConnectionState.none:
                                return const Center(
                                  child: Text(
                                      "Error: Could not get subjects from storage"),
                                );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                    child: Center(
                      child: Text(
                        'Today\'s Tasks',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Change color as needed
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ), // Add spacing between sections
                  Expanded(
                    flex: 2,
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return Container(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color.fromARGB(255, 113, 13, 116),
                                  Color.fromARGB(255, 20, 1, 20)
                                ], // Purple, black, purple
                                begin: _topAlignmentAnimation
                                    .value, // Purple at bottom
                                end: _bottomAlignmentAnimation
                                    .value, // Purple at top
                              ), // Set background color here
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(60.0),
                                topRight: Radius.circular(60.0),
                                bottomLeft:
                                    Radius.zero, // Square bottom-left corner
                                bottomRight:
                                    Radius.zero, // Square bottom-right corner
                              ), // Set border radius here
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(60.0),
                                topRight: Radius.circular(60.0),
                              ),
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (_, index) => TaskTimeline(
                                        task: taskList[index],
                                        subjectColor: taskList[index].color,
                                        gradient:
                                            taskList[index].gradientColors,
                                        isFirst: index == 0,
                                        isLast: index == taskList.length - 1,
                                        refreshCallback: () {
                                          setState(() {});
                                        },
                                      ),
                                      childCount: taskList.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubject(BuildContext context, Subject subject) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DetailPage(),
          ),
        );
      },
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: _topAlignmentAnimation.value, // Purple at bottom
                  end: _bottomAlignmentAnimation.value, // Purple at top
                  colors: subject.gradientColors,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    subject.iconAssetPath,
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildTaskStatus(
                        Colors.black,
                        Colors.white,
                        '${subject.numTasksLeft} left',
                        Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildTaskStatus(
    Color bgColor,
    Color txColor,
    String text,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    TextEditingController subjectController = TextEditingController();
    Color? selectedColor1;
    Color? selectedColor2;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(), // Apply dark theme
          child: AlertDialog(
            backgroundColor: Colors.grey[900], // Set background color
            title: Text(
              "Add Subject",
              style: TextStyle(color: Colors.white), // Set text color
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: subjectController,
                    style: TextStyle(color: Colors.white), // Set text color
                    decoration: InputDecoration(
                      labelText: "Subject Name",
                      labelStyle:
                          TextStyle(color: Colors.white), // Set text color
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Select gradient colors:",
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Colors.grey[900], // Set background color
                                title: Text(
                                  "Select First Color",
                                  style: TextStyle(
                                      color: Colors.white), // Set text color
                                ),
                                content: MaterialColorPicker(
                                  onColorChange: (Color color) {
                                    setState(() {
                                      selectedColor1 = color;
                                    });
                                  },
                                  selectedColor: selectedColor1 ??
                                      Color.fromARGB(255, 0, 172, 0),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                          color:
                                              Colors.white), // Set text color
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedColor1 ?? Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Colors.grey[900], // Set background color
                                title: Text(
                                  "Select Second Color",
                                  style: TextStyle(
                                      color: Colors.white), // Set text color
                                ),
                                content: MaterialColorPicker(
                                  onColorChange: (Color color) {
                                    setState(() {
                                      selectedColor2 = color;
                                    });
                                  },
                                  selectedColor: selectedColor2 ?? Colors.blue,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                          color:
                                              Colors.white), // Set text color
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedColor2 ??
                                Color.fromARGB(255, 56, 253, 99),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
                onPressed: () {
                  // Add subject logic here
                  // You can use subjectController.text for subject name
                  // selectedColor1 and selectedColor2 for gradient colors
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
