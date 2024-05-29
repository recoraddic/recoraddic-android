import 'package:flutter/material.dart';
import 'package:recoraddic/types/quest.dart';

import 'style.dart';

class Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function(BuildContext)? onPressed;

  const Section({
    super.key,
    required this.title,
    required this.subtitle,
    this.onPressed,
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
            IconButton(
              onPressed: () => onPressed?.call(context),
              icon: Transform.scale(
                scale: 1.5,
                child: const Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
              style: IconButton.styleFrom(
                // overlayColor: Colors.transparent,
              ),
              visualDensity: VisualDensity.compact,
            )
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

class DiarySection extends StatelessWidget {
  final String diary;
  final Future Function() deleteDiary;
  final void Function(BuildContext) showDiaryModal;

  const DiarySection({
    super.key,
    required this.diary,
    required this.deleteDiary,
    required this.showDiaryModal,
  });

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
                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 200), () {
                  if (context.mounted) {
                    showDiaryModal(context);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제하기'),
              onTap: () async {
                if (context.mounted) {
                  Navigator.pop(context);
                }

                await deleteDiary();
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

class AccumulatedQuestSection extends StatelessWidget {
  final List<Quest> accumulatedQuestList;
  final Future Function(int) updateAccumulatedQuest;
  final Future Function(int) deleteAccumulatedQuest;
  final void Function(BuildContext) showAccumulatedQuestModal;

  const AccumulatedQuestSection({
    super.key,
    required this.accumulatedQuestList,
    required this.updateAccumulatedQuest,
    required this.deleteAccumulatedQuest,
    required this.showAccumulatedQuestModal,
  });

  void _showMenu(BuildContext context, int index) {
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

                await deleteAccumulatedQuest(index);
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
                '누적 퀘스트',
                style: AppFonts.middleWhiteText,
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              onPressed: () => showAccumulatedQuestModal(context),
              icon: Transform.scale(
                scale: 1.5,
                child: const Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
              style: IconButton.styleFrom(
                // overlayColor: Colors.transparent,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: accumulatedQuestList.length,
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
                    color: accumulatedQuestList[index].isDone
                        ? AppColors.middleGreyColor
                        : AppColors.darkGreyColor,
                    borderRadius:
                        BorderRadius.circular(AppConstants.bigBorderRadius),
                  ),
                  child: TextButton.icon(
                    onPressed: () async {
                      await updateAccumulatedQuest(index);
                    },
                    icon: Icon(
                      accumulatedQuestList[index].isDone
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: accumulatedQuestList[index].isDone
                          ? AppColors.lightBlueColor
                          : AppColors.darkBlueColor,
                    ),
                    label: Text(
                      accumulatedQuestList[index].quest,
                      style: accumulatedQuestList[index].isDone
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

class NormalQuestSection extends StatelessWidget {
  final List<Quest> normalQuestList;
  final Future Function(int) updateNormalQuest;
  final Future Function(int) deleteNormalQuest;
  final void Function(BuildContext, {int? index}) showNormalQuestModal;

  const NormalQuestSection({
    super.key,
    required this.normalQuestList,
    required this.updateNormalQuest,
    required this.deleteNormalQuest,
    required this.showNormalQuestModal,
  });

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
                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 200), () {
                  if (context.mounted) {
                    showNormalQuestModal(context, index: index);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제하기'),
              onTap: () async {
                if (context.mounted) {
                  Navigator.pop(context);
                }

                await deleteNormalQuest(index);
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
              onPressed: () => showNormalQuestModal(context),
              icon: Transform.scale(
                scale: 1.5,
                child: const Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
              style: IconButton.styleFrom(
                // overlayColor: Colors.transparent,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.bigBoxSize),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: normalQuestList.length,
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
                    color: normalQuestList[index].isDone
                        ? AppColors.middleGreyColor
                        : AppColors.darkGreyColor,
                    borderRadius:
                        BorderRadius.circular(AppConstants.bigBorderRadius),
                  ),
                  child: TextButton.icon(
                    onPressed: () async {
                      await updateNormalQuest(index);
                    },
                    icon: Icon(
                      normalQuestList[index].isDone
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: normalQuestList[index].isDone
                          ? AppColors.lightBlueColor
                          : AppColors.darkBlueColor,
                    ),
                    label: Text(
                      normalQuestList[index].quest,
                      style: normalQuestList[index].isDone
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
