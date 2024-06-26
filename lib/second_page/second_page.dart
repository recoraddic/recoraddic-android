import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recoraddic/first_page/function/calendarfunc.dart';
import 'package:recoraddic/types/daily_record.dart';
import 'package:recoraddic/types/accumulated_quest.dart';
import 'package:recoraddic/types/quest.dart';

import '../style/style.dart';
import 'widget.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late Box<DailyRecord> _dailyRecordBox;
  late Box<AccumulatedQuest> _accumulatedQuestListBox;
  late DailyRecord _dailyRecord;
  late List<AccumulatedQuest> _accumulatedQuestList;
  late Future<void> _initBoxFuture;

  @override
  void initState() {
    super.initState();

    _initBoxFuture = _initBox();
  }

  Future _initBox() async {
    String date = DateTime.now().toIso8601String().split('T')[0];

    _dailyRecordBox = await Hive.openBox<DailyRecord>('dailyRecordBox');
    _accumulatedQuestListBox =
        await Hive.openBox<AccumulatedQuest>('accumulatedQuestListBox');

    // 오늘 날짜의 기록이 삭제될 경우 호출
    _dailyRecordBox.watch(key: date).listen((event) {
        // 오늘 기록을 가져오고, UI 업데이트
        setState(() {
        _dailyRecord = _dailyRecordBox.get(date) ??
          DailyRecord(
            date: DateTime.now(),
            diary: '',
            dailyQuestList_accumulated: [],
            dailyQuestList_normal: [],
            facialExpressionIndex: -1,
            isSaved: false,
          );          
        });
    });

    _accumulatedQuestListBox.watch().listen((event) {
      _accumulatedQuestList = _accumulatedQuestListBox.values.toList();
    });

    setState(() {
      _dailyRecord = _dailyRecordBox.get(date) ??
          DailyRecord(
            date: DateTime.now(),
            diary: '',
            dailyQuestList_accumulated: [],
            dailyQuestList_normal: [],
            facialExpressionIndex: -1,
            isSaved: false,
          );
      _accumulatedQuestList = _accumulatedQuestListBox.values.toList();
    });
  }

  Future _saveDailyRecord() async {
    String date = DateTime.now().toIso8601String().split('T')[0];

    await _dailyRecordBox.put(date, _dailyRecord);
  }

  Future _deleteDiary() async {
    setState(() {
      _dailyRecord.diary = '';
    });

    await _saveDailyRecord();
  }

  Future _updateAccumulatedQuest(int index) async {
    for (var accumulatedQuest in _accumulatedQuestList) {
      if (accumulatedQuest.quest.name ==
          _dailyRecord.dailyQuestList_accumulated[index].name) {

        DateTime date = normalize(DateTime.now());
        if (_dailyRecord.dailyQuestList_accumulated[index].isDone) {
          accumulatedQuest.dates.remove(date);
        } else {
          if (!accumulatedQuest.dates.contains(date)) {
            accumulatedQuest.dates.add(date);
          }
        }
        await accumulatedQuest.save();
      }
    }

    setState(() {
      _dailyRecord.dailyQuestList_accumulated[index].isDone =
          !_dailyRecord.dailyQuestList_accumulated[index].isDone;
    });

    await _saveDailyRecord();
  }

  Future _deleteAccumulatedQuest(int index) async {
    setState(() {
      _dailyRecord.dailyQuestList_accumulated.removeAt(index);
    });

    await _saveDailyRecord();
  }

  Future _updateNormalQuest(int index) async {
    setState(() {
      _dailyRecord.dailyQuestList_normal[index].isDone =
          !_dailyRecord.dailyQuestList_normal[index].isDone;
    });

    await _saveDailyRecord();
  }

  Future _deleteNormalQuest(int index) async {
    setState(() {
      _dailyRecord.dailyQuestList_normal.removeAt(index);
    });

    await _saveDailyRecord();
  }

  void _showDiaryModal(BuildContext context) {
    final TextEditingController diaryController = TextEditingController();

    if (_dailyRecord.diary != '') {
      diaryController.text = _dailyRecord.diary;
    }

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
                  Text('오늘의 일기', style: AppFonts.middleWhiteText(context)),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  TextField(
                    maxLines: null,
                    controller: diaryController,
                    cursorColor: AppColors.lightBlueColor,
                    decoration: const InputDecoration(
                      hintText: '오늘의 일기를 입력하세요.',
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
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        String diary = diaryController.text;

                        if (diary.isNotEmpty) {
                          setState(() {
                            _dailyRecord.diary = diary;
                          });

                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          diaryController.clear();

                          await _saveDailyRecord();
                        }
                      },
                      buttonText: _dailyRecord.diary == '' ? '저장하기' : '수정하기',
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAccumulatedQuestModal(BuildContext context) {
    List<DailyQuest> curAccumulatedQuestList = [];

    for (var accumulatedQuest in _accumulatedQuestList) {
      String questName = accumulatedQuest.quest.name;
      if (!_dailyRecord.dailyQuestList_accumulated.map((dailyQuest) => dailyQuest.name).contains(questName)) {
        curAccumulatedQuestList.add(DailyQuest(name: questName, isDone: false));
      }
    }



    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (curAccumulatedQuestList.isEmpty) {
          return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[ Text("추가 가능한 누적 퀘스트가 없습니다.")]);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...List.generate(
              curAccumulatedQuestList.length,
              (index) {
                {
                  return ListTile(
                    leading: const SizedBox(),
                    title: Text(curAccumulatedQuestList[index].name),
                    onTap: () async {
                      setState(() {
                        _dailyRecord.dailyQuestList_accumulated.add(
                          curAccumulatedQuestList[index],
                        );
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      await _saveDailyRecord();
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showNormalQuestModal(BuildContext context, {int? index}) {
    final TextEditingController diaryController = TextEditingController();

    if (index != null) {
      diaryController.text = _dailyRecord.dailyQuestList_normal[index].name;
    }

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
                  Text('일반 퀘스트', style: AppFonts.middleWhiteText(context)),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  TextField(
                    controller: diaryController,
                    cursorColor: AppColors.lightBlueColor,
                    decoration: const InputDecoration(
                      hintText: '일반 퀘스트를 입력하세요.',
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
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        String normalQuest = diaryController.text;

                        if (normalQuest.isNotEmpty) {
                          setState(() {
                            if (index == null) {
                              _dailyRecord.dailyQuestList_normal.add(
                                DailyQuest(name: normalQuest, isDone: false),
                              );
                            } else {
                              _dailyRecord.dailyQuestList_normal[index].name =
                                  normalQuest;
                            }
                          });

                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          diaryController.clear();

                          await _saveDailyRecord();
                        }
                      },
                      buttonText: index == null ? '추가하기' : '수정하기',
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSaveModal(BuildContext context) {
    List<bool> isSelected = List.generate(123, (_) => false);
    int curIndex = _dailyRecord.facialExpressionIndex;

    if (curIndex != -1) {
      isSelected[curIndex] = true;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialog) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_dailyRecord.isSaved ? '수정하기' : '저장하기',
                        style: AppFonts.middleWhiteText(context)),
                    const SizedBox(height: AppConstants.smallBoxSize),
                    Text('오늘을 표현할 표정을 고르세요!',
                        style: AppFonts.smallLightGreyText(context)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      margin: const EdgeInsets.symmetric(
                        vertical: AppConstants.smallPadding,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor,
                      ),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: 123,
                        itemBuilder: (context, index) {
                          return InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                setDialog(() {
                                  curIndex = index;
                                  isSelected = List.generate(123, (_) => false);
                                  isSelected[index] = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected[index]
                                      ? AppColors.lightGreyColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.bigBorderRadius),
                                ),
                                child: Image.asset(
                                  'assets/facial/facialExpression_${index + 1}.png',
                                  fit: BoxFit.cover,
                                ),
                              ));
                        },
                      ),
                    ),
                    Center(
                      child: CustomElevatedButton(
                          onPressed: () async {
                            if (curIndex != -1) {
                              setState(() {
                                _dailyRecord.facialExpressionIndex = curIndex;
                                _dailyRecord.isSaved = true;
                              });

                              if (context.mounted) {
                                Navigator.pop(context);
                              }

                              await _saveDailyRecord();
                            }
                          },
                          buttonText: _dailyRecord.isSaved ? '수정하기' : '저장하기'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initBoxFuture,
      builder: (context, snapshot) {
        {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: AppConstants.topPadding, bottom: AppConstants.bigPadding, left: AppConstants.bigPadding, right: AppConstants.bigPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '체크리스트',
                        style: AppFonts.bigWhiteText(context),
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    _dailyRecord.diary == ''
                        ? Section(
                            title: '오늘의 일기',
                            subtitle: '오늘의 일기를 추가해보세요!',
                            onPressed: _showDiaryModal,
                          )
                        : DiarySection(
                            diary: _dailyRecord.diary,
                            deleteDiary: _deleteDiary,
                            showDiaryModal: _showDiaryModal,
                          ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.bigPadding),
                      child: Divider(
                          thickness: 0.5, color: AppColors.lightGreyColor),
                    ),
                    _dailyRecord.dailyQuestList_accumulated.isEmpty
                        ? Section(
                            title: '누적 퀘스트',
                            subtitle: '누적 퀘스트를 추가해보세요!',
                            onPressed: _showAccumulatedQuestModal,
                          )
                        : AccumulatedQuestSection(
                            accumulatedQuestList:
                                _dailyRecord.dailyQuestList_accumulated,
                            updateAccumulatedQuest: _updateAccumulatedQuest,
                            deleteAccumulatedQuest: _deleteAccumulatedQuest,
                            showAccumulatedQuestModal:
                                _showAccumulatedQuestModal),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.bigPadding),
                      child: Divider(
                          thickness: 0.5, color: AppColors.lightGreyColor),
                    ),
                    _dailyRecord.dailyQuestList_normal.isEmpty
                        ? Section(
                            title: '일반 퀘스트',
                            subtitle: '일반 퀘스트를 추가해보세요!',
                            onPressed: _showNormalQuestModal,
                          )
                        : NormalQuestSection(
                            normalQuestList: _dailyRecord.dailyQuestList_normal,
                            updateNormalQuest: _updateNormalQuest,
                            deleteNormalQuest: _deleteNormalQuest,
                            showNormalQuestModal: _showNormalQuestModal),
                    Center(
                      child: CustomElevatedButton(
                        onPressed: () {
                          _showSaveModal(context);
                        },
                        buttonText: _dailyRecord.isSaved ? '수정하기' : '저장하기',
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
