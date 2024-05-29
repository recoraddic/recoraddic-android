// goal_layout.dart

// libraries
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// types
import '../types/section_record.dart';

class GoalLayout extends StatefulWidget {
  final SectionRecord sectionRecord;

  GoalLayout({required this.sectionRecord});

  @override
  _GoalLayoutState createState() => _GoalLayoutState();
}

class _GoalLayoutState extends State<GoalLayout> {
  TextEditingController _newGoalController = TextEditingController();

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
              itemCount: widget.sectionRecord.goalList.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.sectionRecord.goalList.length) {
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
                        '${index + 1}. ${widget.sectionRecord.goalList[index]}',
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
                    widget.sectionRecord.goalList.add(_newGoalController.text);
                    _saveGoals();
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
    _newGoalController.text = widget.sectionRecord.goalList[index];
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
                  widget.sectionRecord.goalList.removeAt(index);
                  _saveGoals();
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
                    widget.sectionRecord.goalList[index] = _newGoalController.text;
                    _saveGoals();
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

  Future<void> _saveGoals() async {
    var sectionRecordBox = await Hive.openBox<SectionRecord>('sectionRecordBox');
    var section = sectionRecordBox.values.firstWhere((element) => element.key == widget.sectionRecord.key);
    section.goalList = widget.sectionRecord.goalList;
    await section.save();
  }
}
