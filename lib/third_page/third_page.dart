// third_layout.dart

// libraries
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// types
import '../types/daily_record.dart';
import '../types/section_record.dart';

// classes
import './record_layout.dart';
import './goal_layout.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  PageController _pageController = PageController();
  
  late Box<DailyRecord> dailyRecordBox;
  late Box<SectionRecord> sectionRecordBox;

  List<DailyRecord> dailyRecords = [];
  List<SectionRecord> sectionRecordList = [];
  Map<SectionRecord, List<DailyRecord>> sectionedDailyRecords = {};

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    // Ensure that the adapters are registered only once
    // if (!Hive.isAdapterRegistered(0)) {
    //   Hive.registerAdapter(DailyRecordAdapter());
    // }
    // if (!Hive.isAdapterRegistered(1)) {
    //   Hive.registerAdapter(SectionRecordAdapter());
    // }

    dailyRecordBox = await Hive.openBox<DailyRecord>('dailyRecordBox');
    sectionRecordBox = await Hive.openBox<SectionRecord>('sectionRecordBox');
    _loadData();
  }

  // Box(disk) -> List(memory)
  void _loadData() {
    setState(() {
      dailyRecords = dailyRecordBox.values.toList();
      sectionRecordList = sectionRecordBox.values.toList();
      
      // Ensure there's at least one sectionRecord
      if (sectionRecordList.isEmpty) {
        sectionRecordList.add(
          SectionRecord(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 30)),
            goalList: [],
            blockColor: Colors.brown.value,
          ),
        );
        _saveData(); // Save the newly added default sectionRecord
      }

      _divideDailyRecordsBySection();
    });
  }

  void _divideDailyRecordsBySection() {
    sectionedDailyRecords.clear();
    for (var section in sectionRecordList) {
      sectionedDailyRecords[section] = dailyRecords.where((record) {
        return record.date.isAfter(section.startDate) && record.date.isBefore(section.endDate);
      }).toList();
    }
  }

  Future<void> _saveData() async {
    await dailyRecordBox.clear();
    for (var record in dailyRecords) {
      dailyRecordBox.add(record);
    }
    
    await sectionRecordBox.clear();
    for (var record in sectionRecordList) {
      sectionRecordBox.add(record);
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
    if (_pageController.page! < sectionedDailyRecords.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _showColorPickerDialog(BuildContext context, Color initialColor, ValueChanged<Color> onColorChanged) {
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
        SectionRecord currentSection = sectionRecordList[currentPageIndex];
        Color initialColor = Color(currentSection.blockColor);

        _showColorPickerDialog(context, initialColor, (Color newColor) {
          setState(() {
            currentSection.blockColor = newColor.value;
            _saveData();
          });
        });
        break;

      case '새로운 보관함 생성':
        setState(() {
          sectionRecordList.add(SectionRecord(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 30)),
            goalList: [],
            blockColor: Colors.brown.value,
          ));
          _divideDailyRecordsBySection();
          _pageController.jumpToPage(sectionRecordList.length - 1);
          _saveData();
        });
        break;

      case '보관함 삭제':
        setState(() {
          if (sectionRecordList.length > 1) {
            int currentPageIndex = _pageController.page!.round();
            sectionRecordList.removeAt(currentPageIndex);
            _divideDailyRecordsBySection();

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

  Widget _buildPageContent(SectionRecord sectionRecord, List<DailyRecord> dailyRecords) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double recordHeight = constraints.maxHeight * 0.65;
        double goalHeight = constraints.maxHeight * 0.35;

        return Column(
          children: [
            Container(
              height: recordHeight,
              child: RecordLayout(
                dailyRecords: dailyRecords,
                blockColor: Color(sectionRecord.blockColor),
              ),
            ),
            Container(
              height: goalHeight,
              child: GoalLayout(sectionRecord: sectionRecord),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double iconHeight = 50.0;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: sectionedDailyRecords.entries.map((entry) {
              return _buildPageContent(entry.key, entry.value);
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
