import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FactorScoreWidget extends StatelessWidget {
  const FactorScoreWidget({required this.value, super.key});

  final int value;

  Color get color {
    if (value >= 80) {
      return Colors.green;
    } else if (value >= 60) {
      return Colors.lime;
    } else if (value >= 40) {
      return Colors.yellow;
    } else if (value >= 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 24,
      percent: value / 100,
      center: Text(value.toString()),
      progressColor: color,
    );
  }
}
