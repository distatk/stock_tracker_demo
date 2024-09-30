import 'package:flutter/material.dart';
import 'package:stock_tracker_demo/data_models/ranking.dart';

class RankingWidget extends StatelessWidget {
  const RankingWidget({required this.ranking, super.key});

  final Ranking ranking;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: ranking.rank.toString(),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        children: [
          TextSpan(
            text: '/',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextSpan(
            text: ranking.totalMember.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }
}
