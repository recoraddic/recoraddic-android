import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:test_flutter/models/goal.dart';
import '../types/goal.dart';

class GoalLayout extends StatefulWidget {
  final List<Goal> goalList;

  const GoalLayout({super.key, required this.goalList});

  @override
  _GoalLayoutState createState() => _GoalLayoutState();
}

class _GoalLayoutState extends State<GoalLayout> {
  final TextEditingController _newGoalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[300],
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                '목표',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.goalList.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.goalList.length) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.2,
                        child: ElevatedButton(
                          onPressed: () {
                            _showAddGoalDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[50],
                            foregroundColor: Colors.black,
                          ),
                          child: Text('추가'),
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      _showEditOrDeleteGoalDialog(context, index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 32.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '${index + 1}. ${widget.goalList[index].title}',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 18.0),
                      ),
                    ),
                  );
                }
              },
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    _newGoalController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('목표 추가'),
          content: TextField(
            controller: _newGoalController,
            decoration: const InputDecoration(hintText: '새로운 목표'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newGoalController.text.isNotEmpty) {
                  setState(() {
                    widget.goalList.add(Goal(title: _newGoalController.text));
                    _saveGoals();
                  });
                  _newGoalController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _showEditOrDeleteGoalDialog(BuildContext context, int index) {
    _newGoalController.text = widget.goalList[index].title;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('목표 수정'),
          content: TextField(
            controller: _newGoalController,
            decoration: const InputDecoration(hintText: '목표 수정'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.goalList.removeAt(index);
                  _saveGoals();
                });
                _newGoalController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newGoalController.text.isNotEmpty) {
                  setState(() {
                    widget.goalList[index].title = _newGoalController.text;
                    _saveGoals();
                  });
                  _newGoalController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveGoals() async {
    var goalBox = await Hive.openBox<Goal>('goalBox');
    await goalBox.clear();
    for (var goal in widget.goalList) {
      await goalBox.add(goal);
    }
  }
}
