// third_page.dart

// packages
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// types
import '../types/daily_record.dart';
import '../types/section.dart';

// classes
import './record_layout.dart';
import './goal_layout.dart';

class SectionRecord {
  Section section;
  List<DailyRecord> dailyRecords;

  SectionRecord({
    required this.section,
    required this.dailyRecords,
  });
}

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  PageController _pageController = PageController();

  late Box<DailyRecord> _dailyRecordBox;
  late Box<Section> _sectionBox;

  List<DailyRecord> _savedDailyRecords = []; // 저장된 일일 기록
  List<Section> _savedSections = []; // 저장된 구간
  List<SectionRecord> sectionRecords = []; // 구간별 일일 기록

  @override
  void initState() {
    super.initState();
    _initBox();
  }

  Future<void> _initBox() async {
    // Open Hive boxes
    _dailyRecordBox = await Hive.openBox<DailyRecord>('dailyRecordBox');
    _sectionBox = await Hive.openBox<Section>('sectionBox');

    // Load data from Hive boxes
    _loadData();
  }

  // Box(disk) -> List(memory)
  void _loadData() {
    setState(() {
      // 저장된 일일 기록만 불러오기
      _savedDailyRecords = _dailyRecordBox.values.where((record) => record.isSaved).toList();
      _savedSections = _sectionBox.values.toList();

      // 구간이 없는 경우 기본 구간 생성
      if (_savedSections.isEmpty) {
        _savedSections = [
          Section(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 30)),
            goalList: [],
            blockColor: Colors.brown.value,
          ),
        ];
      }
      print('Local data has been loaded.');

      // 구간 기록 초기화
      sectionRecords.clear(); // Ensure sectionRecords is empty before adding new records
      for (var section in _savedSections) {
        List<DailyRecord> dailyRecords = [];
        for (var record in _savedDailyRecords) {
          // Include records on start and end dates
          if (!record.date.isBefore(section.startDate) && !record.date.isAfter(section.endDate)) {
            dailyRecords.add(record);
          }
        }

        sectionRecords.add(SectionRecord(
          section: section,
          dailyRecords: dailyRecords,
        ));
      }

      print('${sectionRecords.length} sections have been initialized.');
    });
  }

  void _saveData() {
    _saveSection();
    _saveDailyRecords();
  }

  // Save sections to Hive box
  void _saveSection() {
    // Update memory data
    _savedSections.clear();
    for (var sectionRecord in sectionRecords) {
      _savedSections.add(sectionRecord.section.copyWith());
    }

    // Clear existing data
    _sectionBox.clear();

    // Save sections
    _sectionBox.addAll(_savedSections);
  }

  // Save daily records to Hive box
  void _saveDailyRecords() {
    // Update total records before saving

    _savedDailyRecords.clear();
    for (var sectionRecord in sectionRecords) {
      _savedDailyRecords.addAll(sectionRecord.dailyRecords);
    }

    // Clear existing data
    _dailyRecordBox.clear();

    // Save daily records with date as key
    for (var dailyRecord in _savedDailyRecords) {
      String dateKey = dailyRecord.date.toIso8601String().split('T')[0];
      _dailyRecordBox.put(dateKey, dailyRecord);
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
    if (_pageController.page! < sectionRecords.length - 1) {
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
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onPopupMenuSelected(String value) {
    switch (value) {
      case '보관함 스타일 변경':
        int currentPageIndex = _pageController.page!.round();

        Color initialColor = Color(sectionRecords[currentPageIndex].section.blockColor);

        _showColorPickerDialog(context, initialColor, (Color newColor) {
          setState(() {
            // 현재 section의 blockColor를 변경
            sectionRecords[currentPageIndex].section.blockColor = newColor.value;

            // 로컬 저장소에 변경사항 저장
            _saveData();
          });
        });

        break;

      case '새로운 보관함 생성':
        setState(() {
          int lastSectionIndex = sectionRecords.length - 1;

          // empty인 구간이 존재하는 경우 생성 불가
          if (sectionRecords[lastSectionIndex].dailyRecords.isEmpty) {
            // print('이전 구간이 비어있어 새로운 구간을 생성할 수 없습니다.');
            _showErrorDialog(context, '마지막 구간 기록이 비어있어 새로운 구간을 생성할 수 없습니다.');
            return;
          }

          // 마지막 구간의 종료일을 현재 시간으로 변경
          sectionRecords[lastSectionIndex].section.endDate = DateTime.now();

          // 새로운 구간 생성
          sectionRecords.add(SectionRecord(
            section: Section(
              startDate: DateTime.now(),
              endDate: DateTime.now().add(Duration(days: 30)),
              goalList: [],
              blockColor: Colors.brown.value,
            ),
            dailyRecords: [],
          ));

          // 새로 생성된 페이지로 이동
          _pageController.jumpToPage(sectionRecords.length - 1);

          // 로컬 저장소에 변경사항 저장
          _saveData();
        });
        break;

      case '보관함 삭제':
        setState(() {
          // 구간 기록이 하나만 존재하는 경우
          // 삭제 후 빈 구간을 생성
          if (sectionRecords.length == 1) {
            sectionRecords.clear();

            sectionRecords.add(SectionRecord(
              section: Section(
                startDate: DateTime.now(),
                endDate: DateTime.now().add(Duration(days: 30)),
                goalList: [],
                blockColor: Colors.brown.value,
              ),
              dailyRecords: [],
            ));

            // 첫 번째 페이지로 이동
            _pageController.jumpToPage(0);
          }

          // 구간 기록이 두 개 이상 존재하는 경우
          else if (sectionRecords.length > 1) {
            int currentPageIndex = _pageController.page!.round();
            print('삭제하려는 페이지: ${currentPageIndex}');

            // 해당 페이지의 구간 기록 삭제
            sectionRecords.removeAt(currentPageIndex);

            // 이전 페이지로 이동
            if (currentPageIndex > 0) {
              _pageController.jumpToPage(currentPageIndex - 1);
            }
            // 첫 페이지로 이동
            else {
              _pageController.jumpToPage(0);
            }
          }

          // 로컬 저장소에 변경사항 저장
          _saveData();
        });
        break;
    }
  }

  Widget _buildPageContent(Section section, List<DailyRecord> dailyRecords) {
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
                blockColor: Color(section.blockColor),
                onRecordChanged: _saveData,
              ),
            ),
            Container(
              height: goalHeight,
              child: GoalLayout(
                section: section,
                onGoalChanged: _saveData,
              ),
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
            children: sectionRecords.map((sectionRecord) {
              return _buildPageContent(
                  sectionRecord.section, sectionRecord.dailyRecords);
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
