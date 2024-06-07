// record_layout.dart

// packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// classes
import '../style/style.dart';

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
    shape: const RoundedRectangleBorder(
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
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.bigPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      formattedDate,
                      style: AppFonts.middleWhiteText(context),
                    ),
                  ),
                  const SizedBox(height: AppConstants.bigPadding),
                  if (record.diary.isNotEmpty) ...[
                    Text(
                      '그날의 일기',
                      style: AppFonts.middleWhiteText(context),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: AppColors.middleGreyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        record.diary,
                        style: AppFonts.smallWhiteText(context),
                      ),
                    ),
                    const SizedBox(height: AppConstants.bigPadding),
                    const Divider(
                      thickness: 0.5,
                      color: AppColors.lightGreyColor,
                    ),
                    const SizedBox(height: AppConstants.bigPadding),
                  ],
                  if (record.dailyQuestList_accumulated.any((quest) => quest.isDone)) ...[
                    Text(
                      '누적 퀘스트',
                      style: AppFonts.middleWhiteText(context),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    ...record.dailyQuestList_accumulated
                        .where((quest) => quest.isDone)
                        .map((quest) => _buildQuestItem(quest))
                        .toList(),
                    const SizedBox(height: AppConstants.bigPadding),
                    const Divider(
                      thickness: 0.5,
                      color: AppColors.lightGreyColor,
                    ),
                    const SizedBox(height: AppConstants.bigPadding),
                  ],
                  if (record.dailyQuestList_normal.any((quest) => quest.isDone)) ...[
                    Text(
                      '일반 퀘스트',
                      style: AppFonts.middleWhiteText(context),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    ...record.dailyQuestList_normal
                        .where((quest) => quest.isDone)
                        .map((quest) => _buildQuestItem(quest))
                        .toList(),
                    const SizedBox(height: AppConstants.bigPadding),
                  ],
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
                        children: const [
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




  Widget _buildQuestItem(DailyQuest quest) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: AppColors.middleGreyColor,
        borderRadius: BorderRadius.circular(AppConstants.bigBorderRadius),
      ),
      child: Row(
        children: [
          Icon(
            quest.isDone ? Icons.check_circle : Icons.circle_outlined,
            color: AppColors.lightBlueColor,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Text(
            quest.name,
            style: AppFonts.smallWhiteText(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordBlock(Color blockColor, int facialExpressionIndex, DateTime date) {
    String formattedDate = DateFormat('yyyy/M/d').format(date);

    return Row(
      children: [
        // Left empty box
        Expanded(
          child: SizedBox(),
        ),

        // Record block 크기
        Container(
          width: 90,
          height: 60,
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
            child: Image.asset('assets/facial/facialExpression_${facialExpressionIndex + 1}.png'),
          ),
        ),

        // Right box with formatted date
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.bigPadding), // Adjust this value as needed
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                formattedDate,
                style: AppFonts.smallLightGreyText(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.recordBackground,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 폰트 고정
                Text('기록보관함', style: AppFonts.bigWhiteText(context)),
              ],
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: widget.dailyRecords.length,
                itemBuilder: (context, index) {
                  var dailyRecord = widget.dailyRecords[index];
                  return Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => _showRecordDetails(dailyRecord),
                      child: _buildRecordBlock(
                        widget.blockColor,
                        dailyRecord.facialExpressionIndex,
                        dailyRecord.date, // Pass the date here
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
