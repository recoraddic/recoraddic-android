// goal_layout.dart

// packages
import 'package:flutter/material.dart';

// types
import '../types/section.dart';

import '../style/style.dart';

class GoalLayout extends StatefulWidget {
  final Section section;
  final VoidCallback onGoalChanged;

  GoalLayout({required this.section, required this.onGoalChanged});

  @override
  _GoalLayoutState createState() => _GoalLayoutState();
}

class _GoalLayoutState extends State<GoalLayout> {
  TextEditingController _newGoalController = TextEditingController();

  // 목표 추가 눌렀을 때
  void _showAddGoalDialog(BuildContext context) {
    _newGoalController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('목표 추가', style: AppFonts.middleWhiteText),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  TextField(
                    controller: _newGoalController,
                    cursorColor: AppColors.lightBlueColor,
                    decoration: const InputDecoration(
                      hintText: '새로운 목표',
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(AppConstants.smallPadding),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightGreyColor, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightBlueColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  OneButtonWidget(
                    buttonText: '추가하기',
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 목표를 클릭한 경우
  void _showEditOrDeleteGoalDialog(BuildContext context, int index) {
    _newGoalController.text = widget.section.goalList[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('목표 수정', style: AppFonts.middleWhiteText),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  TextField(
                    controller: _newGoalController,
                    cursorColor: AppColors.lightBlueColor,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(AppConstants.smallPadding),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightGreyColor, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightBlueColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TwoButtonWidget(
                    buttonText1: '삭제',
                    onPressed1: () {
                      setState(() {
                        widget.section.goalList.removeAt(index);
                        widget.onGoalChanged(); // Call the callback function
                      });
                      _newGoalController.clear();
                      Navigator.of(context).pop();
                    },
                    buttonText2: '수정',
                    onPressed2: () {
                      if (_newGoalController.text.isNotEmpty) {
                        setState(() {
                          widget.section.goalList[index] = _newGoalController.text;
                          widget.onGoalChanged(); // Call the callback function
                        });
                        _newGoalController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.goalBackground,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
              // 텍스트 스타일 통일
              child: const Text('목표', style: AppFonts.bigWhiteText),
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
                            backgroundColor: AppColors.goalBlock,
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
                        color: AppColors.goalBlock,
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
