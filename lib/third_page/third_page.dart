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
import '../style/style.dart';


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

  late Future<void> _initBoxFuture;
  late Box<DailyRecord> _dailyRecordBox; // 일일 기록(로컬)
  late Box<Section> _sectionBox; // 구간(로컬)

  List<DailyRecord> _totalDailyRecords = []; // 일일 기록(메모리)
  List<Section> _totalSections = []; // 구간(메모리)
  List<SectionRecord> _sectionRecords = []; // 구간별 일일 기록(메모리)

  @override
  void initState() {
    super.initState();
    _initBoxFuture = _updateBox();
  }

  Future<void> _updateBox() async {
    // 로컬 박스를 열기
    _dailyRecordBox = await Hive.openBox<DailyRecord>('dailyRecordBox');
    _sectionBox = await Hive.openBox<Section>('sectionBox');

    String date = DateTime.now().toIso8601String().split('T')[0];

    // 오늘 기록에 변화가 감지되면 sectionRecord를 업데이트
    _dailyRecordBox.watch(key: date).listen((event) {
      _totalDailyRecords = _dailyRecordBox.values.where((record) => record.isSaved).toList();

      setState(() {
        // 구간별 일일 기록 업데이트(메모리)
        _updateSectionRecords();
      });
    });

    // Load data from Hive boxes
    _loadData();
  }

  void _loadData() {
    _loadDailyRecords();    // 일일 기록 가져오기
    _loadSections();        // 구간 가져오기

    setState(() {
      _updateSectionRecords();
    });
  }
  
  // Box(disk) -> List(memory)
  void _loadDailyRecords() {
    _totalDailyRecords = _dailyRecordBox.values.where((record) => record.isSaved).toList();
  }

  void _loadSections() {
    _totalSections = _sectionBox.values.toList();
    // 구간이 없는 경우 오늘을 구간 생성
    if (_totalSections.length == 0) {
      // 시작 날짜 오늘 0시 0분 0초
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      // 끝나는 날짜 30일 후 23시 59분 59초
      DateTime endDate = startDate.add(Duration(days: 30, hours: 23, minutes: 59, seconds: 59));
      _totalSections = [
        Section(
          startDate: startDate,
          endDate: endDate,
          goalList: [],
          blockColor: Colors.brown.value,
        ),
      ];
    }
  }

  void _updateSectionRecords() {
    // 구간 시작 날짜를 기준으로 정렬
    _totalSections.sort((a, b) => a.startDate.compareTo(b.startDate));

    // 일일 기록 날짜를 기준으로 정렬
    _totalDailyRecords.sort((a, b) => a.date.compareTo(b.date));

    // Clear and update _sectionRecords
    _sectionRecords.clear();

    for (var section in _totalSections) {
      List<DailyRecord> dailyRecords = [];
      for (var record in _totalDailyRecords) {
        // Save records that are after the section's start date and before the section's end date
        if (record.date.isAfter(section.startDate) &&
            record.date.isBefore(section.endDate)) {
          dailyRecords.add(record);
        }
      }

      _sectionRecords.add(SectionRecord(
        section: section,
        dailyRecords: dailyRecords,
      ));
    }

    print('${_sectionRecords.length} sections have been updated.');
  }

  // 구간을 로컬에 저장
  Future<void> _saveSections() async {
    // sectionRecords를 바탕으로 구간 업데이트
    _totalSections.clear();
    for (var sectionRecord in _sectionRecords) {
      _totalSections.add(sectionRecord.section.copyWith());
    }

    // 구간 시작 날짜를 키로 하여 박스에 저장
    _sectionBox.clear();
    for (var section in _totalSections) {
      String startDateKey = section.startDate.toIso8601String().split('T')[0];
      _sectionBox.put(startDateKey, section);
    }
  }

  // 일일 기록을 로컬에 저장
  Future<void> _saveDailyRecords() async {
    // sectionRecords를 바탕으로 일일 기록 업데이트
    _totalDailyRecords.clear();
    for (var sectionRecord in _sectionRecords) {
      _totalDailyRecords.addAll(sectionRecord.dailyRecords);
    }

    // 날짜를 키로 하여 박스에 저장
    _dailyRecordBox.clear();
    for (var dailyRecord in _totalDailyRecords) {
      String dateKey = dailyRecord.date.toIso8601String().split('T')[0];
      await _dailyRecordBox.put(dateKey, dailyRecord);
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
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('오류', style: AppFonts.middleWhiteText(context)),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  Text(message, style: AppFonts.smallWhiteText(context)),
                  OneButtonWidget(
                    buttonText: '확인',
                    onPressed: () {
                      Navigator.of(context).pop();
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

  void _onPopupMenuSelected(String value) {
    switch (value) {
      case '보관함 스타일 변경':
        int currentPageIndex = _pageController.page!.round();

        Color initialColor =
            Color(_sectionRecords[currentPageIndex].section.blockColor);

        _showColorPickerDialog(context, initialColor, (Color newColor) {
          setState(() {
            // 현재 section의 blockColor를 변경
            _sectionRecords[currentPageIndex].section.blockColor =
                newColor.value;
          });
          // 로컬 저장소에 변경사항 저장
          // block color는 section에 대한 업데이트
          _saveSections();
        });

        break;

      case '새로운 보관함 생성':
        int lastSectionIndex = _sectionRecords.length - 1;

        // 마지막 구간 기록에 저장된 일일 기록이 없다면 새로운 보관함 생성 불가
        if (_sectionRecords[lastSectionIndex].dailyRecords.isEmpty) {
          _showErrorDialog(context, '현재 구간 기록이 비어있어 새로운 보관함을 생성할 수 없어요.');
          return;
        }

        // 오늘 날짜의 기록이 이미 저장되어있다면 새로운 보관함 생성 불가
        DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        bool todaysRecordExists = _sectionRecords.any((sectionRecord) {
          return sectionRecord.dailyRecords.any((record) {
            DateTime recordDate =
                DateTime(record.date.year, record.date.month, record.date.day);
            return recordDate == today;
          });
        });

        if (todaysRecordExists) {
          _showErrorDialog(
              context, '오늘의 기록이 이미 저장되었네요.\n내일 새로운 보관함을 생성할 수 있어요!');
          return;
        }

        setState(() {
          // 마지막 구간의 종료일을 어제로 변경
          DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
          DateTime endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
          
          _sectionRecords[lastSectionIndex].section.endDate = endDate;

          // 시작날짜 오늘 0시 0분 0초, 끝나는 날짜 30일 후 23시 59분 59초
          DateTime newStartDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          DateTime newEndDate = newStartDate.add(Duration(days: 30, hours: 23, minutes: 59, seconds: 59));

          Section newSection = Section(
            startDate: newStartDate,
            endDate: newEndDate,
            goalList: [],
            blockColor: Colors.brown.value,
          );

          _sectionRecords.add(SectionRecord(section: newSection, dailyRecords: []));
        });

        // 로컬 저장소에 변경사항 저장
        _saveSections();
        break;

      case '보관함 삭제':
        setState(() {
          // 구간 기록이 하나만 존재하는 경우
          // 삭제 후 빈 구간을 생성
          if (_sectionRecords.length == 1) {
            _sectionRecords.clear();

            // 시작날짜 오늘 0시 0분 0초, 끝나는 날짜 30일 후 23시 59분 59초
            DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
            DateTime endDate = startDate.add(Duration(days: 30, hours: 23, minutes: 59, seconds: 59));
            _sectionRecords.add(SectionRecord(
              section: Section(
                startDate: startDate,
                endDate: endDate,
                goalList: [],
                blockColor: Colors.brown.value,
              ),
              dailyRecords: [],
            ));

            // 첫 번째 페이지로 이동
            _pageController.jumpToPage(0);
          }

          // 구간 기록이 두 개 이상 존재하는 경우
          else if (_sectionRecords.length > 1) {
            int currentPageIndex = _pageController.page!.round();
            print('삭제하려는 페이지: ${currentPageIndex}');

            // 해당 페이지의 구간 기록 삭제
            _sectionRecords.removeAt(currentPageIndex);

            // 이전 페이지로 이동
            if (currentPageIndex > 0) {
              _pageController.jumpToPage(currentPageIndex - 1);
            }
            // 첫 페이지로 이동
            else {
              _pageController.jumpToPage(0);
            }
          }
        });

        // 일일 기록과 구간 모두 로컬에 저장
        _saveSections();
        _saveDailyRecords();
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
                onRecordChanged: _saveDailyRecords,
              ),
            ),
            Container(
              height: goalHeight,
              child: GoalLayout(
                section: section,
                onGoalChanged: _saveSections,
              ),
            ),
          ],
        );
      },
    );
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
    if (_pageController.page! < _sectionRecords.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconHeight = 50.0;
    int totalPages = _sectionRecords.length;
    int currentPageIndex =
        _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;

    return FutureBuilder(
        future: _initBoxFuture,
        builder: (context, snapshot) {
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Scaffold(
                body: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      children: _sectionRecords.map((sectionRecord) {
                        return _buildPageContent(
                            sectionRecord.section, sectionRecord.dailyRecords);
                      }).toList(),
                      onPageChanged: (index) {
                        setState(() {}); // Trigger a rebuild to update icons
                      },
                    ),
                    Positioned(
                      left: 10,
                      top: (MediaQuery.of(context).size.height / 2),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          size: iconHeight,
                          color: (currentPageIndex == 0 || totalPages == 1)
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black,
                        ),
                        onPressed: (currentPageIndex == 0 || totalPages == 1)
                            ? null
                            : _previousPage,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: (MediaQuery.of(context).size.height / 2),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_circle_right_outlined,
                          size: iconHeight,
                          color: (currentPageIndex == totalPages - 1 ||
                                  totalPages == 1)
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.black,
                        ),
                        onPressed: (currentPageIndex == totalPages - 1 ||
                                totalPages == 1)
                            ? null
                            : _nextPage,
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
        });
  }
}
