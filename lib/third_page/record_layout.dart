// record_layout.dart

// libraries
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// types
import '../types/quest.dart';
import '../types/daily_record.dart';

class RecordLayout extends StatefulWidget {
  final List<DailyRecord> dailyRecords;
  final Color blockColor;

  RecordLayout({
    required this.dailyRecords,
    required this.blockColor,
  });

  @override
  RecordLayoutState createState() => RecordLayoutState();
}

class RecordLayoutState extends State<RecordLayout> {
  void _showRecordDetails(DailyRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Set this value to show more of the sheet initially
          minChildSize: 0.6, // Ensure the minimum size matches the initial size
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        record.date.toString(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '오늘의 일기',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        record.diary,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '누적 퀘스트',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...record.accumulatedQuestList.map((quest) => _buildQuestItem(quest)).toList(),
                    SizedBox(height: 16),
                    Text(
                      '일반 퀘스트',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...record.normalQuestList.map((quest) => _buildQuestItem(quest)).toList(),
                    SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.dailyRecords.remove(record);
                            _saveRecords();
                            Navigator.of(context).pop();
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '기록 삭제하기',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveRecords() async {
    var dailyRecordBox = await Hive.openBox<DailyRecord>('dailyRecordBox');
    await dailyRecordBox.clear();
    for (var record in widget.dailyRecords) {
      await dailyRecordBox.add(record);
    }
  }

  Widget _buildQuestItem(Quest quest) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            quest.isDone ? Icons.check_circle : Icons.circle_outlined,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            quest.quest,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordBlock(double width, double height, Color blockColor, int facialExpressionIndex) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 2), // Offset in x and y directions
          ),
        ],
      ),
      child: Center(
        child: Image.asset('assets/facialExpression_$facialExpressionIndex.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300], // Set the background color of the entire container
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '기록보관함',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: widget.dailyRecords.length,
                itemBuilder: (context, index) {
                  var record = widget.dailyRecords[index];
                  return Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => _showRecordDetails(record),
                      child: _buildRecordBlock(
                        75,
                        50,
                        widget.blockColor,
                        record.facialExpressionIndex,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
