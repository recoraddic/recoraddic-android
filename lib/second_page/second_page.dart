import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<bool> todaysDiary = List.filled(3, false);
  List<bool> cumulativeQuest = List.filled(3, false);
  List<bool> dailyQuest = List.filled(3, false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildArea('오늘의 일기', todaysDiary),
        Divider(color: Colors.black), // This is the line
        buildArea('누적 퀘스트', cumulativeQuest),
        Divider(color: Colors.black), // This is the line
        buildArea('일일 퀘스트', dailyQuest),
      ],
    );
  }

  Widget buildArea(String title, List<bool> tasks) {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(title),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text('Task ${index + 1}'),
                    value: tasks[index],
                    onChanged: (newValue) {
                      setState(() {
                        tasks[index] = newValue!;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}