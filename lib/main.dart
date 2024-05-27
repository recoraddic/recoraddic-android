import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:test_flutter/first_page/first_page.dart';
// // import 'package:test_flutter/second_page/second_page.dart';
// import 'package:test_flutter/third_page/third_layout.dart';
// import 'package:test_flutter/fourth_page/fourth_page.dart';
// import 'package:test_flutter/models/record.dart';
// import 'package:test_flutter/models/goal.dart';
// import 'package:test_flutter/models/third_page_content.dart';
// import 'package:test_flutter/second_page/checklist.dart';
// import 'package:test_flutter/first_page/questThumbnail.dart';


import 'first_page/first_page.dart';
// import 'package:test_flutter/second_page/second_page.dart';
import 'third_page/third_layout.dart';
import 'fourth_page/fourth_page.dart';
import 'models/record.dart';
import 'models/goal.dart';
import 'models/third_page_content.dart';
import 'second_page/checklist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization
  await Hive.initFlutter();
  Hive.registerAdapter(RecordAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(ThirdPageContentAdapter());

  await _initializeDefaultData();

  runApp(const MyApp());
}

Future<void> _initializeDefaultData() async {
  var recordBox = await Hive.openBox<Record>('recordBox');
  var goalBox = await Hive.openBox<Goal>('goalBox');
  var thirdPageBox = await Hive.openBox<ThirdPageContent>('thirdPageBox');

  // // Clear existing data
  // await recordBox.clear();
  // await goalBox.clear();
  // await thirdPageBox.clear();

  // Add default records
  if (recordBox.isEmpty) {
    await recordBox.addAll([
      Record(
        date: '2024년 05월 12일',
        diary: '오늘은 집에서 잠을 잤다.\n참 재미있었다.',
        accumulatedQuest: ['물 마시기', '운동하기'],
        normalQuest: ['우유 먹기'],
        facialExpressionIndex: 0,
      ),
      Record(
        date: '2024년 05월 13일',
        diary: '오늘은 학교에 갔다.\n공부를 열심히 했다.',
        accumulatedQuest: ['물 마시기'],
        normalQuest: ['산책하기'],
        facialExpressionIndex: 1,
      ),
      Record(
        date: '2024년 05월 14일',
        diary: '오늘은 학교에 갔다.\n공부를 열심히 했다.',
        accumulatedQuest: ['물 마시기'],
        normalQuest: ['산책하기'],
        facialExpressionIndex: 2,
      ),
      // Add more default records as needed
    ]);
  }

  if (goalBox.isEmpty) {
    // Add default goals
    await goalBox.addAll([
      Goal(title: '밥 먹기'),
      Goal(title: '책 읽기'),
      Goal(title: '운동'),
      // Add more default goals as needed
    ]);
  }

  if (thirdPageBox.isEmpty) {
    // Add default third page contents
    await thirdPageBox.addAll([
      ThirdPageContent(
        recordList: recordBox.values.toList(),
        goalList: goalBox.values.toList(),
        blockColor: Colors.brown.value,
      ),
      ThirdPageContent(
        recordList: recordBox.values.toList(),
        goalList: goalBox.values.toList(),
        blockColor: Colors.brown.value,
      ),
      // Add more default third page contents as needed
    ]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '기록중독',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//         primarySwatch: Colors.blue,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         // 어두운 테마 설정
//         useMaterial3: true,
//         primarySwatch: Colors.blue,
//         brightness: Brightness.dark,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          FirstPage(),
          CheckList(),
          ThirdPage(),
          FourthPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fire_extinguisher),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
