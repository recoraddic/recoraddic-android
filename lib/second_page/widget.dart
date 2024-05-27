import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'style.dart';

class Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool flag;
  final void Function(BuildContext, String, String?) onPressed;

  const Section({
    super.key,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallBoxSize),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppConstants.smallPadding),
              child: Text(
                title,
                style: AppFonts.middleWhiteText,
              ),
            ),
            flag
                ? IconButton(
                    onPressed: () => onPressed(context, '추가하기', null),
                    icon: Transform.scale(
                      scale: 1.5,
                      child: const Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                        size: 24,
                      ),
                    ),
                    style: IconButton.styleFrom(
                      hoverColor: Colors.transparent,
                    ),
                    visualDensity: VisualDensity.compact,
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
        Center(
          child: Text(
            subtitle,
            style: AppFonts.smallLightGreyText,
          ),
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
      ],
    );
  }
}

class Diary extends StatelessWidget {
  final String diary;
  final SharedPreferences prefs;
  final void Function() loadDiary;
  final void Function(BuildContext, String, String?) showDiaryModal;

  const Diary(
      {super.key,
      required this.diary,
      required this.prefs,
      required this.loadDiary,
      required this.showDiaryModal});

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('수정하기'),
              onTap: () {
                showDiaryModal(context, '수정하기', diary);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제하기'),
              onTap: () {
                String curDate =
                    '${DateTime.now().toIso8601String().split('T')[0]}-diary';

                prefs.remove(curDate);
                loadDiary();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallBoxSize),
        const Padding(
          padding: EdgeInsets.only(left: AppConstants.smallPadding),
          child: Text(
            '오늘의 일기',
            style: AppFonts.middleWhiteText,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding),
            child: GestureDetector(
              onLongPress: () {
                _showMenu(context);
              },
              child: Container(
                padding: const EdgeInsets.all(AppConstants.bigPadding),
                decoration: BoxDecoration(
                  color: AppColors.middleGreyColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.bigBorderRadius),
                ),
                child: Text(
                  diary,
                  style: AppFonts.smallWhiteText,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
      ],
    );
  }
}

class AccumulateQuest extends StatelessWidget {
  final List<String> accumulateQuestList;
  final List<String> accumulateCheckList;
  final void Function(int) updateAccumulateCheck;

  const AccumulateQuest({
    super.key,
    required this.accumulateQuestList,
    required this.accumulateCheckList,
    required this.updateAccumulateCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallBoxSize),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: AppConstants.smallPadding),
              child: Text(
                '누적 퀘스트',
                style: AppFonts.middleWhiteText,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(),
          ],
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: accumulateQuestList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding),
              child: Container(
                margin:
                    const EdgeInsets.only(bottom: AppConstants.smallBoxSize),
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.smallPadding,
                    horizontal: AppConstants.bigPadding),
                decoration: BoxDecoration(
                  color: accumulateCheckList[index] == 'true'
                      ? AppColors.middleGreyColor
                      : AppColors.darkGreyColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.bigBorderRadius),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    updateAccumulateCheck(index);
                  },
                  icon: Icon(
                    accumulateCheckList[index] == 'true'
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: accumulateCheckList[index] == 'true'
                        ? AppColors.lightBlueColor
                        : AppColors.darkBlueColor,
                  ),
                  label: Text(
                    accumulateQuestList[index],
                    style: accumulateCheckList[index] == 'true'
                        ? AppFonts.smallWhiteText
                        : AppFonts.smallLightGreyText,
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                    overlayColor: Colors.transparent,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CommonQuest extends StatelessWidget {
  final List<String> commonQuestList;
  final List<String> commonCheckList;
  final Future Function(String) saveCommonQuest;
  final Future Function(List<String>, List<String>) saveCommonQuestList;
  final void Function() loadCommonQuestList;
  final void Function(int) updateCommonCheck;
  final void Function(BuildContext, String, String?, {int? index})
      showCommonQuestModal;

  const CommonQuest(
      {super.key,
      required this.commonQuestList,
      required this.commonCheckList,
      required this.saveCommonQuest,
      required this.saveCommonQuestList,
      required this.loadCommonQuestList,
      required this.updateCommonCheck,
      required this.showCommonQuestModal});

  void _showMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('수정하기'),
              onTap: () {
                showCommonQuestModal(context, '수정하기', commonQuestList[index],
                    index: index);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제하기'),
              onTap: () async {
                commonQuestList.removeAt(index);
                commonCheckList.removeAt(index);

                await saveCommonQuestList(commonQuestList, commonCheckList);

                loadCommonQuestList();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallBoxSize),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: AppConstants.smallPadding),
              child: Text(
                '일반 퀘스트',
                style: AppFonts.middleWhiteText,
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              onPressed: () => showCommonQuestModal(context, '추가하기', null),
              icon: Transform.scale(
                scale: 1.5,
                child: const Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
              style: IconButton.styleFrom(
                hoverColor: Colors.transparent,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commonQuestList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding),
              child: GestureDetector(
                onLongPress: () {
                  _showMenu(context, index);
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: AppConstants.smallBoxSize),
                  padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.smallPadding,
                      horizontal: AppConstants.bigPadding),
                  decoration: BoxDecoration(
                    color: commonCheckList[index] == 'true'
                        ? AppColors.middleGreyColor
                        : AppColors.darkGreyColor,
                    borderRadius:
                        BorderRadius.circular(AppConstants.bigBorderRadius),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      updateCommonCheck(index);
                    },
                    icon: Icon(
                      commonCheckList[index] == 'true'
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: commonCheckList[index] == 'true'
                          ? AppColors.lightBlueColor
                          : AppColors.darkBlueColor,
                    ),
                    label: Text(
                      commonQuestList[index],
                      style: commonCheckList[index] == 'true'
                          ? AppFonts.smallWhiteText
                          : AppFonts.smallLightGreyText,
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                      overlayColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomElevatedButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallBoxSize),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBlueColor,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.bigBorderRadius),
            ),
          ),
          child: Text(
            buttonText,
            style: AppFonts.smallWhiteText,
          ),
        ),
      ],
    );
  }
}
