// record_layout.dart

// packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// types
import '../types/quest.dart';
import '../types/daily_record.dart';

class RecordLayout extends StatefulWidget {
  final List<DailyRecord> dailyRecords;
  final Color blockColor;
  final VoidCallback onRecordChanged;

  RecordLayout({
    required this.dailyRecords,
    required this.blockColor,
    required this.onRecordChanged,
  });

  @override
  RecordLayoutState createState() => RecordLayoutState();
}

class RecordLayoutState extends State<RecordLayout> {
  @override
  void initState() {
    super.initState();
  }

  void _showRecordDetails(DailyRecord record) {
    // Format the date using intl package
    String formattedDate = DateFormat('yyyy년 M월 d일').format(record.date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
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
                        formattedDate,
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
                            widget.onRecordChanged(); // Call the callback function
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
            quest.name,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordBlock(Color blockColor, int facialExpressionIndex) {
    return Container(
      width: 75,
      height: 50,
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Image.asset('assets/facial/facialExpression_$facialExpressionIndex.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
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
                  var dailyRecords = widget.dailyRecords[index];
                  return Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => _showRecordDetails(dailyRecords),
                      child: _buildRecordBlock(
                        widget.blockColor,
                        dailyRecords.facialExpressionIndex,
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
