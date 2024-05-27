import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:test_flutter/models/record.dart';
import '../models/record.dart';

class RecordLayout extends StatefulWidget {
  final List<Record> recordList;
  final Color blockColor;

  RecordLayout({
    required this.recordList,
    required this.blockColor,
  });

  @override
  RecordLayoutState createState() => RecordLayoutState();
}

class RecordLayoutState extends State<RecordLayout> {
  // List of facial expression image paths
  final List<String> facialExpressions = [
    'assets/facialExpression_1.png',
    'assets/facialExpression_2.png',
    'assets/facialExpression_3.png', // Add more paths as needed
  ];

  void _showRecordDetails(Record record) {
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
                        record.date,
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
                    ...record.accumulatedQuest.map((quest) => _buildQuestItem(quest, true)).toList(),
                    SizedBox(height: 16),
                    Text(
                      '일반 퀘스트',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...record.normalQuest.map((quest) => _buildQuestItem(quest, false)).toList(),
                    SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.recordList.remove(record);
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
    var recordBox = await Hive.openBox<Record>('recordBox');
    await recordBox.clear();
    for (var record in widget.recordList) {
      await recordBox.add(record);
    }
  }

  Widget _buildQuestItem(String text, bool completed) {
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
            completed ? Icons.check_circle : Icons.circle_outlined,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            text,
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
        child: Image.asset(facialExpressions[facialExpressionIndex]),
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
                itemCount: widget.recordList.length,
                itemBuilder: (context, index) {
                  var record = widget.recordList[index];
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
