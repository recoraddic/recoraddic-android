import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void showColorPickerDialog(BuildContext context, Color initialColor,
    ValueChanged<Color> onColorChanged) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text('보관함 스타일 변경'),
        ),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: initialColor,
            onColorChanged: onColorChanged,
          ),
        ),
      );
    },
  );
}

void showGoalListDialog(BuildContext context, List<String> goalList,
    Function(String) onAddGoal, Function(String) onDeleteGoal) {
  TextEditingController goalController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('목표 편집'),
            content: SingleChildScrollView(
              child: ListBody(
                children: goalList.map((goal) {
                  return Row(
                    children: [
                      Expanded(child: Text(goal)),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                // title: Text('Confirm'),
                                content: const Text('정말 삭제하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('삭제'),
                                    onPressed: () {
                                      setState(() {
                                        goalList.remove(goal);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextField(
                controller: goalController,
                decoration: const InputDecoration(
                  labelText: '새로운 목표',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (goalController.text.isNotEmpty) {
                    onAddGoal(goalController.text);
                    goalController.clear();
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
