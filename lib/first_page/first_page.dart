import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'function/calendarfunc.dart';
import 'questThumbnail.dart';
import 'package:recoraddic/types/accumulated_quest.dart';


class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  late Box<AccumulatedQuest> _accumulatedQuestListBox;
  List<AccumulatedQuest> _accumulatedQuestList = [];
  late Future<void> _initBoxFuture;

  @override
  void initState() {
    super.initState();

    _initBoxFuture = _initBox();
  }

  Future _initBox() async {

    _accumulatedQuestListBox =
        await Hive.openBox<AccumulatedQuest>('accumulatedQuestListBox');

    setState(() {
      _accumulatedQuestList = _accumulatedQuestListBox.values.toList();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text("누적 퀘스트 보관함")),
      ),
      body: Center(
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
                      child: QuestStatistics(index: index),
                    );
                  },
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
      ),
    );
  }
}

class QuestStatistics extends StatelessWidget {
  final int index;

  const QuestStatistics({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final DateTime now = normalize(DateTime.now());
    final Map<DateTime, int> data = Map.fromEntries([
      MapEntry(now, 1),
      MapEntry(now.subtract(const Duration(days: 1)), 0),
      // MapEntry(DateTime.now().subtract(const Duration(days: -2)), 0),
      MapEntry(now.subtract(const Duration(days: 3)), 0),
      // MapEntry(DateTime.now().subtract(const Duration(days: -4)), 0),
      MapEntry(now.subtract(const Duration(days: 5)), 12),
      MapEntry(now.subtract(const Duration(days: 6)), 5),
      // MapEntry(DateTime.now().subtract(const Duration(days: -7)), 0),
      MapEntry(now.subtract(const Duration(days: 8)), 10),
      MapEntry(now.subtract(const Duration(days: 9)), 2),
      MapEntry(now.subtract(const Duration(days: 10)), 1),
      MapEntry(now.subtract(const Duration(days: 30)), 1),
      // MapEntry(DateTime.now().subtract(const Duration(days: -11)), 0),
    ]
        // List.generate(
        //   Random().nextInt(10),
        //   (index) => MapEntry(
        //     DateTime.now().subtract(Duration(days: Random().nextInt(365))),
        //     Random().nextInt(2),
        //   )
        // )
        );

    if (data.isEmpty) {
      return const SizedBox();
    } else {
      List<DateTime> sortedKeys = List<DateTime>.from(data.keys);
      sortedKeys.sort();
      DateTime startDate = sortedKeys.first;
      DateTime endDate = sortedKeys.last;
      int termLength = endDate.difference(startDate).inDays + 1;

      double elementWidth = width * 0.8;
      double calendarContentWidth = width * 0.7;
      double calendarElementSize = calendarContentWidth / 7;
      double scrollHeight =
          (termLength / 7.0 + 2) * (calendarContentWidth / 7.0);

      return Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.03),
          child: Text(
            "QuestName $index",
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
              SizedBox(
                width: calendarContentWidth,
                height: height * 0.3,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: calendarContentWidth,
                    height: scrollHeight,
                    child: SerialVisualization(data: data),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);
    }
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
