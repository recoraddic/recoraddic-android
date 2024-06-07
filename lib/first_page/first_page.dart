import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'function/calendarfunc.dart';
import 'questThumbnail.dart';
import 'package:recoraddic/types/quest.dart';
import 'package:recoraddic/types/accumulated_quest.dart';
// import 'package:recoraddic/second_page/style.dart';
import 'package:recoraddic/second_page/widget.dart';

import '../style/style.dart';

// 할일: delete accumulatedQuest, 추가 시 이름 같은 것 막기

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  late Box<AccumulatedQuest> _accumulatedQuestListBox;
  late List<AccumulatedQuest> _accumulatedQuestList;
  late Future<void> _initBoxFuture;

  @override
  void initState() {
    super.initState();

    _initBoxFuture = _updateBox();
  }

  Future _updateBox() async {
    
    _accumulatedQuestListBox =
        await Hive.openBox<AccumulatedQuest>('accumulatedQuestListBox');

    _accumulatedQuestListBox.watch().listen((event) {
      for (var accumulatedQuest in _accumulatedQuestListBox.values) {
        accumulatedQuest.update();
      }
    });
    // await _accumulatedQuestListBox.clear();

    for (var accumulatedQuest in _accumulatedQuestListBox.values) {
      accumulatedQuest.update();
    }
    setState(() {
      _accumulatedQuestList = _accumulatedQuestListBox.values.toList();
    });

  }

  void _insertAccumulatedQuest(String key) {
    _accumulatedQuestListBox.put(key,AccumulatedQuest(
      quest: DailyQuest(name: key, isDone: false),
    )).then((_) {
      _updateBox();
   });
  }

  _deleteAccumulatedQuest(String key) {
    _accumulatedQuestListBox.delete(key).then((_) {
      _updateBox();
   });
  }


  void _showMenu(BuildContext context, String key) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제하기'),
              onTap: () async {
                if (context.mounted) {
                  Navigator.pop(context);
                }
                await {
                  setState(() {
                    _deleteAccumulatedQuest(key);
                  }),
                };
              },
            ),
          ],
        );
      },
    );
  }

  void _inputForNewAccumulatedQuest(BuildContext context) {
    final TextEditingController nameController = TextEditingController();


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
                  Text('새로운 누적 퀘스트', style: AppFonts.middleWhiteText(context)),
                  const SizedBox(height: AppConstants.smallBoxSize),
                  TextField(
                    maxLines: null,
                    controller: nameController,
                    cursorColor: AppColors.lightBlueColor,
                    decoration: const InputDecoration(
                      hintText: '퀘스트 이름을 입력하세요',
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
                  Builder(builder: (context) {
                    if (_accumulatedQuestList.map((e) => e.quest.name).contains(nameController.text)) {
                      return Text('이미 존재하는 퀘스트입니다.', style: AppFonts.smallWhiteText(context));
                    }
                    else {
                      return const SizedBox();
                    }
                  }),

                  Center(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        String newAccumulatedQuestName = nameController.text;

                        if (newAccumulatedQuestName.isNotEmpty) {


                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          nameController.clear();

                          await {
                            setState(() {
                              _insertAccumulatedQuest(newAccumulatedQuestName);
                            }
                            ),
                          };
                        }
                      },
                      buttonText: '추가하기'
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




  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initBoxFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } 
  //       else {  
  //         return Scaffold(
  //           appBar: AppBar(
  //             // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //             title: const Center(child: Text("누적 퀘스트 보관함")),
  //           ),
  //           body: Stack(
  //             children: [
  //               LayoutBuilder(
  //                 builder: (context, constrants) {
  //                   return SizedBox(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: constrants.maxHeight,
  //                     child: GridView.builder(
  //                       padding: const EdgeInsets.all(20),
  //                       itemCount: _accumulatedQuestList.length,
  //                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                         crossAxisCount: 3, // Number of columns
  //                         crossAxisSpacing: 10, // Space between columns
  //                         mainAxisSpacing: 10, // Space between rows
  //                       ),
  //                       itemBuilder: (BuildContext context, int index) {
  //                         return GestureDetector(
  //                           onTap: () {
  //                             showModalBottomSheet(
  //                               context: context,
  //                               isScrollControlled: true,
  //                               builder: (BuildContext context) {
  //                                 return SizedBox(
  //                                   width: MediaQuery.of(context).size.width,
  //                                   height: MediaQuery.of(context).size.height * 0.9,
  //                                   child: QuestStatistics(accumulatedQuest: _accumulatedQuestList[index],),
  //                                 );
  //                               },
  //                             );
  //                           },
  //                           onLongPress: () {
  //                             _showMenu(
  //                               context,
  //                               _accumulatedQuestList[index].quest.name
  //                             );
  //                           },
  //                           child: QuestThumbnail(
  //                             name: _accumulatedQuestList[index].quest.name,
  //                             tier: _accumulatedQuestList[index].tier,
  //                             accumulative: _accumulatedQuestList[index].dates.length,
  //                             momentumLevel: _accumulatedQuestList[index].momentumLevel,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 }
  //               ),
  //               Positioned(
  //                 bottom: 30,
  //                 left: 0,
  //                 right: 0,
  //                 child: IconButton(
  //                   icon: Container(
  //                     width: 50.0, // Set the desired width
  //                     height: 30.0, // Set the desired height
  //                     child: Icon(
  //                       Icons.add,
  //                       size: 30.0, // Adjust the size of the icon inside the container
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     // Handle your button tap here...
  //                     _inputForNewAccumulatedQuest(context);
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     }
  //   );
  // }

  // 스택 사용하지 않고
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initBoxFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else {
  //         return Scaffold(
  //           appBar: AppBar(
  //             title: const Center(child: Text("누적 퀘스트 보관함")),
  //           ),
  //           body: Column(
  //             children: [
  //               Expanded(
  //                 child: LayoutBuilder(
  //                   builder: (context, constraints) {
  //                     return SizedBox(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: constraints.maxHeight,
  //                       child: GridView.builder(
  //                         padding: const EdgeInsets.all(20),
  //                         itemCount: _accumulatedQuestList.length,
  //                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                           crossAxisCount: 3, // Number of columns
  //                           crossAxisSpacing: 10, // Space between columns
  //                           mainAxisSpacing: 10, // Space between rows
  //                         ),
  //                         itemBuilder: (BuildContext context, int index) {
  //                           return GestureDetector(
  //                             onTap: () {
  //                               showModalBottomSheet(
  //                                 context: context,
  //                                 isScrollControlled: true,
  //                                 builder: (BuildContext context) {
  //                                   return SizedBox(
  //                                     width: MediaQuery.of(context).size.width,
  //                                     height: MediaQuery.of(context).size.height * 0.9,
  //                                     child: QuestStatistics(
  //                                       accumulatedQuest: _accumulatedQuestList[index],
  //                                     ),
  //                                   );
  //                                 },
  //                               );
  //                             },
  //                             onLongPress: () {
  //                               _showMenu(
  //                                 context,
  //                                 _accumulatedQuestList[index].quest.name
  //                               );
  //                             },
  //                             child: QuestThumbnail(
  //                               name: _accumulatedQuestList[index].quest.name,
  //                               tier: _accumulatedQuestList[index].tier,
  //                               accumulative: _accumulatedQuestList[index].dates.length,
  //                               momentumLevel: _accumulatedQuestList[index].momentumLevel,
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     );
  //                   }
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 30.0),
  //                 child: IconButton(
  //                   icon: Icon(
  //                     Icons.add,
  //                     size: 40.0,
  //                   ),
  //                   onPressed: () {
  //                     _inputForNewAccumulatedQuest(context);
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initBoxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppConstants.topPadding),
                  child: Center(
                    child: Text(
                      "누적 퀘스트 보관함",
                      style: AppFonts.bigWhiteText(context),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: constraints.maxHeight,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _accumulatedQuestList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns
                            crossAxisSpacing: 10, // Space between columns
                            mainAxisSpacing: 10, // Space between rows
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height * 0.9,
                                      child: QuestStatistics(
                                        accumulatedQuest: _accumulatedQuestList[index],
                                      ),
                                    );
                                  },
                                );
                              },
                              onLongPress: () {
                                _showMenu(
                                  context,
                                  _accumulatedQuestList[index].quest.name
                                );
                              },
                              child: QuestThumbnail(
                                name: _accumulatedQuestList[index].quest.name,
                                tier: _accumulatedQuestList[index].tier,
                                accumulative: _accumulatedQuestList[index].dates.length,
                                momentumLevel: _accumulatedQuestList[index].momentumLevel,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppConstants.bigPadding, bottom: AppConstants.bigPadding),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 40.0,
                    ),
                    onPressed: () {
                      _inputForNewAccumulatedQuest(context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

}

class QuestStatistics extends StatelessWidget {
  final AccumulatedQuest accumulatedQuest;

  const QuestStatistics({super.key, required this.accumulatedQuest});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final DateTime now = normalize(DateTime.now());
    final Map<DateTime, int> data = Map.fromEntries(
      List.generate(accumulatedQuest.dates.length, (int index) => MapEntry(accumulatedQuest.dates[index], 1 )));
      List<DateTime> sortedKeys = List<DateTime>.from(data.keys);
      sortedKeys.sort();


      double elementWidth = width * 0.8;
      double calendarContentWidth = width * 0.7;
      double calendarElementSize = calendarContentWidth / 7;


      return Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.03),
          child: Text(
            "${accumulatedQuest.quest.name}",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          // Calendar
          width: elementWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(elementWidth / 20),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("일", textAlign: TextAlign.center)),
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("월", textAlign: TextAlign.center)),
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("화", textAlign: TextAlign.center)),
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("수", textAlign: TextAlign.center)),
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("목", textAlign: TextAlign.center)),
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("금", textAlign: TextAlign.center)),
                  SizedBox(
                      width: calendarElementSize,
                      height: calendarElementSize,
                      child: const Text("토", textAlign: TextAlign.center)),
                ],
              ),
              Builder(
                builder: (BuildContext context) {
                  if (data.isEmpty) {
                    return SizedBox(
                      width: calendarContentWidth,
                      height: height * 0.3,
                    );
                  } else {
                    DateTime startDate = sortedKeys.first;
                    DateTime endDate = sortedKeys.last;
                    int termLength = endDate.difference(startDate).inDays + 1;
                    double scrollHeight = (termLength / 7.0 + 2) * (calendarContentWidth / 7.0);
                    return SizedBox(
                      width: calendarContentWidth,
                      height: height * 0.3,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: calendarContentWidth,
                          height: scrollHeight,
                          child: SerialVisualization(data: data),
                        ),
                      ),
                    );
                  }
                }
              )
            ],
          ),
        ),
      ]);
    
  }
}

class SerialVisualization extends StatelessWidget {
  final Map<DateTime, int> data;

  const SerialVisualization({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double elementSize = constraints.maxWidth / 7;

        if (data.isEmpty) {
          return const Spacer();
        } else {
          List<DateTime> sortedKeys = List<DateTime>.from(data.keys);
          sortedKeys.sort();
          DateTime firstDate = sortedKeys.first;
          DateTime lastDate = sortedKeys.last;
          List<List<DateTime>> datePartition =
              partitionByWeek(firstDate, lastDate);

          List<DateTime> firstRow = datePartition.first;
          List<DateTime> lastRow = datePartition.last;
          List<bool> doneListFirstRow =
              firstRow.map((date) => data.keys.contains(date)).toList();

          List<Widget> children = [
            SizedBox(
              width: elementSize * 7,
              height: elementSize,
              child: RowContent(
                  dates: firstRow, doneList: doneListFirstRow, isFirst: true),
            ),
          ];

          if (datePartition.length > 1) {
            List<List<DateTime>> middleRows =
                datePartition.sublist(1, datePartition.length - 1);

            for (var row in middleRows) {
              List<bool> doneList =
                  row.map((date) => data.keys.contains(date)).toList();

              children.add(
                SizedBox(
                  width: elementSize * 7,
                  height: elementSize,
                  child: RowContent(dates: row, doneList: doneList),
                ),
              );
            }

            List<bool> doneListLastRow =
                lastRow.map((date) => data.keys.contains(date)).toList();

            children.add(
              SizedBox(
                width: elementSize * 7,
                height: elementSize,
                child: RowContent(
                    dates: lastRow, doneList: doneListLastRow, isLast: true),
              ),
            );
          }

          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(children: children),
          );
        }
      },
    );
  }
}

class RowContent extends StatelessWidget {
  final List<DateTime> dates;
  final List<bool> doneList;
  final bool isFirst;
  final bool isLast;

  const RowContent(
      {super.key,
      required this.dates,
      required this.doneList,
      this.isFirst = false,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    bool containsStartOfMonth = dates.any((date) => date.day == 1);
    bool containsEndOfMonth = dates
        .any((date) => date.day == DateTime(date.year, date.month + 1, 0).day);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return Opacity(
          opacity: 0.8,
          child: Stack(children: <Widget>[
            Row(
              mainAxisAlignment:
                  isFirst ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: dates.asMap().entries.map((entry) {
                int index = entry.key;
                DateTime date = entry.value;
                bool isDone = doneList[index];
                List<Color> colors = isDone
                    ? [
                        Colors.orange.withOpacity(0.7),
                        Colors.red.withOpacity(0.7)
                      ]
                    : [
                        Colors.grey.withOpacity(0.7),
                        Colors.grey.withOpacity(0.7)
                      ];

                return SizedBox(
                  width: width / 7,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('${date.day}'),
                      ),
                      if (date.day == 1)
                        Opacity(
                            opacity: 0.5,
                            child: Center(
                              child: Text('${date.year % 100}/${date.month}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                  )),
                            ))
                    ]),
                  ),
                );
              }).toList(),
            ),
          ]),
        );
      },
    );
  }
}

