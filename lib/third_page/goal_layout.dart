// goal_layout.dart

// packages
import 'package:flutter/material.dart';

// types
import '../types/section.dart';

class GoalLayout extends StatefulWidget {
  final Section section;
  final VoidCallback onGoalChanged;

  GoalLayout({required this.section, required this.onGoalChanged});

  @override
  _GoalLayoutState createState() => _GoalLayoutState();
}

class _GoalLayoutState extends State<GoalLayout> {
  TextEditingController _newGoalController = TextEditingController();

  void _showAddGoalDialog(BuildContext context) {
    _newGoalController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('목표 추가'),
          content: TextField(
            controller: _newGoalController,
            decoration: InputDecoration(hintText: '새로운 목표'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newGoalController.text.isNotEmpty) {
                  setState(() {
                    widget.section.goalList.add(_newGoalController.text);
                    widget.onGoalChanged(); // Call the callback function
                  });
                  _newGoalController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _showEditOrDeleteGoalDialog(BuildContext context, int index) {
    _newGoalController.text = widget.section.goalList[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('목표 수정'),
          content: TextField(
            controller: _newGoalController,
            decoration: InputDecoration(hintText: '목표 수정'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.section.goalList.removeAt(index);
                  widget.onGoalChanged(); // Call the callback function
                });
                _newGoalController.clear();
                Navigator.of(context).pop();
              },
              child: Text('삭제', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newGoalController.text.isNotEmpty) {
                  setState(() {
                    widget.section.goalList[index] = _newGoalController.text;
                    widget.onGoalChanged(); // Call the callback function
                  });
                  _newGoalController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[300],
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                '목표',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.section.goalList.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.section.goalList.length) {
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
                          child: Text('추가'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[50],
                            foregroundColor: Colors.black,
                          ),
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
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '${index + 1}. ${widget.section.goalList[index]}',
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    ),
                  );
                }
              },
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            ),
          ),
        ],
      ),
    );
  }
}
