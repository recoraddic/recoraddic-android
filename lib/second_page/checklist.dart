import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'style.dart';
import 'widget.dart';

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  late SharedPreferences _prefs;

  String? _diary;
  List<String> _commonQuestList = [];
  List<String> _commonCheckList = [];
  List<String> _accumulateQuestList = ['운동하기', '책 읽기', '수학 문제 풀기'];
  List<String> _accumulateCheckList = ['false', 'false', 'false'];
  int? _index;
  Object? _save;

  Future _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future _saveDiary(String diary) async {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    await _prefs.setString('$curDate-diary', diary);
  }

  _loadDiary() {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      _diary = _prefs.getString('$curDate-diary');
    });
  }

  /*
  _loadAccumulateQuestList() {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      _commonQuestList = _prefs.getStringList('$curDate-accumulateQuest') ?? [];
      _commonCheckList = _prefs.getStringList('$curDate-accumulateCheck') ?? [];
    });
  }
  */

  _updateAccumulateCheck(int index) async {
    // String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      _accumulateCheckList[index] =
          _accumulateCheckList[index] == 'true' ? 'false' : 'true';
    });

    // await _prefs.setStringList('$curDate-commonCheck', _commonCheckList);
  }

  Future _saveCommonQuest(String commonQuest, {int? index}) async {
    String curDate = DateTime.now().toIso8601String().split('T')[0];
    List<String> commonQuestList = _commonQuestList;
    List<String> commonCheckList = _commonCheckList;

    if (index == null) {
      commonQuestList.add(commonQuest);
      commonCheckList.add('false');
    } else {
      commonQuestList[index] = commonQuest;
      commonCheckList[index] = 'false';
    }

    await _prefs.setStringList('$curDate-commonQuest', commonQuestList);
    await _prefs.setStringList('$curDate-commonCheck', commonCheckList);
  }

  Future _saveCommonQuestList(
      List<String> commonQuestList, List<String> commonCheckList) async {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    await _prefs.setStringList('$curDate-commonQuest', commonQuestList);
    await _prefs.setStringList('$curDate-commonCheck', commonCheckList);
  }

  _loadCommonQuestList() {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      _commonQuestList = _prefs.getStringList('$curDate-commonQuest') ?? [];
      _commonCheckList = _prefs.getStringList('$curDate-commonCheck') ?? [];
    });
  }

  _updateCommonCheck(int index) async {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      _commonCheckList[index] =
          _commonCheckList[index] == 'true' ? 'false' : 'true';
    });

    await _prefs.setStringList('$curDate-commonCheck', _commonCheckList);
  }

  Future _saveIndex(int index) async {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    await _prefs.setInt('$curDate-index', index);
  }

  _loadIndex() {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      _index = _prefs.getInt('$curDate-index');
    });
  }

  Future _saveSave() async {
    String curDate = DateTime.now().toIso8601String().split('T')[0];
    List<String>? saveDateList = _prefs.getStringList('saveDateList');
    List<String> accumulateQuestList = [];
    List<String> commonQuestList = [];

    if (saveDateList == null) {
      saveDateList = [curDate];
    } else {
      if (!saveDateList.contains(curDate)) {
        saveDateList.add(curDate);
      }
    }

    for (int i = 0; i < _accumulateQuestList.length; i++) {
      if (_accumulateCheckList[i] == 'true') {
        accumulateQuestList.add(_accumulateQuestList[i]);
      }
    }

    for (int i = 0; i < _commonQuestList.length; i++) {
      if (_commonCheckList[i] == 'true') {
        commonQuestList.add(_commonQuestList[i]);
      }
    }

    Object save = {
      'diary': _diary,
      'accumulateQuestList': accumulateQuestList,
      'commonQuestList': commonQuestList,
      'index': _index,
    };
    String jsonSave = jsonEncode(save);

    await _prefs.setString(curDate, jsonSave);
  }

  _loadSave() {
    String curDate = DateTime.now().toIso8601String().split('T')[0];

    setState(() {
      String? save = _prefs.getString(curDate);

      if (save == null) {
        _save = null;
      } else {
        _save = jsonDecode(save);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _initializePrefs();
      _loadDiary();
      _loadCommonQuestList();
      _loadIndex();
      _loadSave();
    });
  }

  void _showDiaryModal(BuildContext context, String buttonText, String? diary) {
    final TextEditingController diaryController = TextEditingController();

    if (diary != null) {
      diaryController.text = diary;
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
                  const Text('오늘의 일기', style: AppFonts.middleWhiteText),
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
                          await _saveDiary(diary);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      buttonText: buttonText,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      diaryController.clear();
      _loadDiary();
    });
  }

  void _showCommonQuestModal(
      BuildContext context, String buttonText, String? commonQuest,
      {int? index}) {
    final TextEditingController diaryController = TextEditingController();

    if (commonQuest != null) {
      diaryController.text = commonQuest;
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
                  const Text('일반 퀘스트', style: AppFonts.middleWhiteText),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  TextField(
                    controller: diaryController,
                    cursorColor: AppColors.lightBlueColor,
                    decoration: const InputDecoration(
                      hintText: '추가할 일반 퀘스트를 입력하세요.',
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
                        String commonQuest = diaryController.text;

                        if (commonQuest.isNotEmpty) {
                          if (index == null) {
                            await _saveCommonQuest(commonQuest);
                          } else {
                            await _saveCommonQuest(commonQuest, index: index);
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      buttonText: buttonText,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      diaryController.clear();
      _loadCommonQuestList();
    });
  }

  void _showSaveModal(BuildContext context, String buttonText) {
    List<bool> isSelected = List.generate(123, (_) => false);
    int? curIndex = _index;

    if (curIndex != null) {
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
                    Text(buttonText, style: AppFonts.middleWhiteText),
                    const SizedBox(height: AppConstants.smallBoxSize),
                    const Text('오늘을 표현할 표정을 고르세요!',
                        style: AppFonts.smallLightGreyText),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      margin: const EdgeInsets.symmetric(
                        vertical: AppConstants.smallPadding,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor,
                        borderRadius:
                            BorderRadius.circular(AppConstants.bigBorderRadius),
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
                                  'assets/facialExpression_${index + 1}.png',
                                  fit: BoxFit.cover,
                                ),
                              ));
                        },
                      ),
                    ),
                    Center(
                      child: CustomElevatedButton(
                          onPressed: () async {
                            if (curIndex != null) {
                              await _saveIndex(curIndex!);
                              await _saveSave();

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          buttonText: buttonText),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).then((_) {
      _loadIndex();
      _loadSave();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.bigPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '체크리스트',
              style: AppFonts.bigWhiteText,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          _diary == null
              ? Section(
                  title: '오늘의 일기',
                  subtitle: '오늘의 일기를 추가해보세요!',
                  flag: true,
                  onPressed: _showDiaryModal)
              : Diary(
                  diary: _diary!,
                  prefs: _prefs,
                  loadDiary: _loadDiary,
                  showDiaryModal: _showDiaryModal),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.bigPadding),
            child: Divider(thickness: 0.5, color: AppColors.lightGreyColor),
          ),
          _accumulateCheckList.isEmpty
              ? Section(
                  title: '누적 퀘스트',
                  subtitle: '누적 퀘스트를 추가해보세요!',
                  flag: false,
                  onPressed: _showDiaryModal)
              : AccumulateQuest(
                  accumulateQuestList: _accumulateQuestList,
                  accumulateCheckList: _accumulateCheckList,
                  updateAccumulateCheck: _updateAccumulateCheck,
                ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.bigPadding),
            child: Divider(thickness: 0.5, color: AppColors.lightGreyColor),
          ),
          _commonQuestList.isEmpty
              ? Section(
                  title: '일반 퀘스트',
                  subtitle: '일반 퀘스트를 추가해보세요!',
                  flag: true,
                  onPressed: _showCommonQuestModal)
              : CommonQuest(
                  commonQuestList: _commonQuestList,
                  commonCheckList: _commonCheckList,
                  saveCommonQuest: _saveCommonQuest,
                  saveCommonQuestList: _saveCommonQuestList,
                  loadCommonQuestList: _loadCommonQuestList,
                  updateCommonCheck: _updateCommonCheck,
                  showCommonQuestModal: _showCommonQuestModal),
          Center(
            child: CustomElevatedButton(
              onPressed: () {
                String buttonText = _save == null ? '저장하기' : '수정하기';

                _showSaveModal(context, buttonText);
              },
              buttonText: _save == null ? '저장하기' : '수정하기',
            ),
          )
        ],
      ),
    );
  }
}
