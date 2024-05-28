// third_layout.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:test_flutter/models/third_page_content.dart';
// import 'package:test_flutter/third_page/goal_layout.dart';
// import 'package:test_flutter/third_page/record_layout.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:test_flutter/models/record.dart';
// import 'package:test_flutter/models/goal.dart';

import '../types/third_page_content.dart';
import '../third_page/goal_layout.dart';
import '../third_page/record_layout.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../types/record.dart';
import '../types/goal.dart';

class ThirdPageContentWidget extends StatelessWidget {
  final List<Record> recordList;
  final List<Goal> goalList;
  final Color blockColor;

  ThirdPageContentWidget({
    required this.recordList,
    required this.goalList,
    this.blockColor = Colors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double recordHeight = constraints.maxHeight * 0.65;
        double goalHeight = constraints.maxHeight * 0.35;

        return Column(
          children: [
            Container(
              height: recordHeight,
              child: RecordLayout(
                recordList: recordList,
                blockColor: blockColor,
              ),
            ),
            Container(
              height: goalHeight,
              child: GoalLayout(goalList: goalList),
            ),
          ],
        );
      },
    );
  }
}

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  PageController _pageController = PageController();
  late Box<ThirdPageContent> thirdPageBox;

  List<ThirdPageContent> _thirdPageInstances = [];

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    // Ensure that the adapters are registered only once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecordAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GoalAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ThirdPageContentAdapter());
    }

    thirdPageBox = await Hive.openBox<ThirdPageContent>('thirdPageBox');
    _loadData();
  }

  void _loadData() {
    setState(() {
      _thirdPageInstances = thirdPageBox.values.toList();
      if (_thirdPageInstances.isEmpty) {
        _thirdPageInstances.add(ThirdPageContent(
          recordList: [],
          goalList: [],
          blockColor: Colors.brown.value,
        ));
      }
    });
  }

  Future<void> _saveData() async {
    await thirdPageBox.clear();
    for (var instance in _thirdPageInstances) {
      await thirdPageBox.add(instance);
    }
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _nextPage() {
    if (_pageController.page! < _thirdPageInstances.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _showColorPickerDialog(BuildContext context, Color initialColor,
      ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('보관함 스타일 변경'),
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: initialColor,
              onColorChanged: (Color color) {
                onColorChanged(color);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  void _onPopupMenuSelected(String value) {
    switch (value) {
      case '보관함 스타일 변경':
        int currentPageIndex = _pageController.page!.round();
        Color initialColor =
            Color(_thirdPageInstances[currentPageIndex].blockColor);

        _showColorPickerDialog(context, initialColor, (Color newColor) {
          setState(() {
            ThirdPageContent currentPage =
                _thirdPageInstances[currentPageIndex];

            _thirdPageInstances[currentPageIndex] = ThirdPageContent(
              recordList: currentPage.recordList,
              goalList: currentPage.goalList,
              blockColor: newColor.value,
            );
            _saveData();
          });
        });
        break;

      case '새로운 보관함 생성':
        setState(() {
          _thirdPageInstances.add(ThirdPageContent(
            recordList: [],
            goalList: [],
            blockColor: Colors.brown.value,
          ));
          _pageController.jumpToPage(_thirdPageInstances.length - 1);
          _saveData();
        });
        break;

      case '보관함 삭제':
        setState(() {
          if (_thirdPageInstances.length > 1) {
            int currentPageIndex = _pageController.page!.round();
            _thirdPageInstances.removeAt(currentPageIndex);

            if (currentPageIndex > 0) {
              _pageController.jumpToPage(currentPageIndex - 1);
            } else {
              _pageController.jumpToPage(0);
            }
            _saveData();
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconHeight = 50.0;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: _thirdPageInstances.map((instance) {
              return ThirdPageContentWidget(
                recordList: instance.recordList,
                goalList: instance.goalList,
                blockColor: Color(instance.blockColor),
              );
            }).toList(),
          ),
          Positioned(
            left: 10,
            top: (MediaQuery.of(context).size.height / 2),
            child: IconButton(
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                size: iconHeight,
              ),
              onPressed: _previousPage,
            ),
          ),
          Positioned(
            right: 10,
            top: (MediaQuery.of(context).size.height / 2),
            child: IconButton(
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                size: iconHeight,
              ),
              onPressed: _nextPage,
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            child: PopupMenuButton<String>(
              onSelected: _onPopupMenuSelected,
              itemBuilder: (BuildContext context) {
                return {'보관함 스타일 변경', '새로운 보관함 생성', '보관함 삭제'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
