import 'package:flutter/material.dart';

class QuestThumbnail extends StatelessWidget {
  final String name;
  final int tier;
  final int momentumLevel;
  final int accumulative;

  const QuestThumbnail(
      {super.key,
      required this.name,
      required this.tier,
      required this.momentumLevel,
      required this.accumulative});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        QuestTierFrame(tier: tier),
        Center(
          // Center the fire
          child: FractionallySizedBox(
              widthFactor: frameInfo[momentumLevel].ratio,
              heightFactor: frameInfo[momentumLevel].ratio,
              child: Fire(momentumLevel: momentumLevel)),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  color: brighten2(getTierColor(tier), -0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "누적: ${accumulative}회",
                style: TextStyle(
                  color: brighten2(getTierColor(tier), -0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Pair {
  final List<String> frames;
  final Duration duration;
  final double ratio;

  Pair(this.frames, this.duration, this.ratio);
}

List<Pair> frameInfo = [
  Pair(List.generate(9, (index) => 'nothing'), const Duration(milliseconds: 75),
      0.95 * 0.85 * 0.85),
  Pair(List.generate(9, (index) => 'assets/fire/fire1_frame${index + 1}.png'),
      const Duration(milliseconds: 750), 0.95 * 0.85 * 0.85),
  Pair(List.generate(9, (index) => 'assets/fire/fire2_frame${index + 1}.png'),
      const Duration(milliseconds: 750), 0.95 * 0.85 * 0.85),
  Pair(List.generate(9, (index) => 'assets/fire/fire3_frame${index + 1}.png'),
      const Duration(milliseconds: 750), 0.95 * 0.85 * 0.85),
  Pair(List.generate(9, (index) => 'assets/fire/fire4_frame${index + 1}.png'),
      const Duration(milliseconds: 600), 0.95 * 0.85 * 0.85),
  Pair(List.generate(6, (index) => 'assets/fire/fire5_frame${index + 1}.png'),
      const Duration(milliseconds: 400), 0.95 * 0.85 * 0.85),
  Pair(List.generate(6, (index) => 'assets/fire/fire6_frame${index + 1}.png'),
      const Duration(milliseconds: 300), 0.95 * 0.85 * 0.85),
  Pair(List.generate(6, (index) => 'assets/fire/fire7_frame${index + 1}.png'),
      const Duration(milliseconds: 240), 0.95 * 0.85),
  Pair(List.generate(6, (index) => 'assets/fire/fire8_frame${index + 1}.png'),
      const Duration(milliseconds: 150), 0.95 * 0.85),
  Pair(List.generate(3, (index) => 'assets/fire/fire9_frame${index + 1}.png'),
      const Duration(milliseconds: 75), 0.95),
  Pair(List.generate(4, (index) => 'assets/fire/fire10_frame${index + 1}.png'),
      const Duration(milliseconds: 33), 1.0)
  // Add more pairs as needed
];

class Fire extends StatefulWidget {
  final int momentumLevel;

  const Fire({super.key, required this.momentumLevel});

  @override
  _FireState createState() => _FireState();
}

class _FireState extends State<Fire> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: frameInfo[widget.momentumLevel].duration);
    _animation = IntTween(
            begin: 0, end: frameInfo[widget.momentumLevel].frames.length - 1)
        .animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (widget.momentumLevel < 1) {
          return Container();
        } else {
          return Opacity(
              opacity: 0.7,
              child: Image.asset(
                frameInfo[widget.momentumLevel].frames[_animation.value],
                fit: BoxFit.fill,
              ));
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class QuestTierFrame extends StatelessWidget {
  final int tier;

  const QuestTierFrame({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: getTierColor(tier),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            getTierColor(tier),
            brighten(getTierColor(tier)),
            getTierColor(tier)
          ],
        ),
      ),
    );
  }
}

Color getTierColor(int tier) {
  switch (tier ~/ 5) {
    case 0:
      return const Color.fromRGBO(112, 112, 112, 1); // Black for other tiers
    case 1:
      return const Color.fromRGBO(136, 112, 74, 1); // Black for other tiers
    case 2:
      return const Color.fromRGBO(195, 195, 195, 1); // Blue for tier 3
    case 3:
      return const Color.fromRGBO(255, 236, 141, 1); // Blue for tier 3
    case 4:
      return const Color.fromRGBO(119, 255, 232, 1.0); // Blue for tier 3
    case 5:
      return const Color.fromRGBO(210, 245, 250, 1.0); // Blue for tier 3
    case 6:
      return const Color.fromRGBO(100, 150, 252, 1.0); // Blue for tier 3
    case 7:
      return const Color.fromRGBO(215, 189, 238, 1.0); // Blue for tier 3
    case 8:
      return const Color.fromRGBO(242, 140, 136, 1.0); // Blue for tier 3
    default:
      return const Color.fromRGBO(112, 112, 112, 1); // Black for other tiers
  }
}

Color brighten(Color color, [int amount = 50]) {
  int red = color.red + amount;
  int green = color.green + amount;
  int blue = color.blue + amount;

  // Ensure color values stay in the valid range (0-255)
  red = red > 255 ? 255 : red;
  green = green > 255 ? 255 : green;
  blue = blue > 255 ? 255 : blue;

  return Color.fromARGB(color.alpha, red, green, blue);
}

Color brighten2(Color color, [double ratio = 0.5]) {
  double multiplier = 1 + ratio > 1 ? 1.0 : (1 + ratio < 0 ? 0.0 : 1 + ratio);
  int red = (color.red * multiplier).toInt();
  int green = (color.green * multiplier).toInt();
  int blue = (color.blue * multiplier).toInt();

  // Ensure color values stay in the valid range (0-255)
  red = red > 255 ? 255 : red;
  green = green > 255 ? 255 : green;
  blue = blue > 255 ? 255 : blue;

  return Color.fromARGB(color.alpha, red, green, blue);
}
