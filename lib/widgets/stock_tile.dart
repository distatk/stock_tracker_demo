import 'package:flutter/material.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';
import 'package:stock_tracker_demo/widgets/stock_rating_widget.dart';

class StockTile extends StatelessWidget {
  const StockTile({required this.stock, super.key});

  final Stock stock;

  Widget _buildRanking(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        stock.rank.toString(),
        key: Key('Ranking'),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildNameAndSubtitle(BuildContext context) {
    return Column(
      key: Key('NameAndSubtitle'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          stock.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          stock.id,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      key: Key('Body'),
      children: [
        _buildRanking(context),
        Expanded(child: _buildNameAndSubtitle(context)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 64,
            child: StockRatingWidget(rating: stock.jittaScore),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            offset: Offset(4, 4), // changes position of shadow
          ),
        ],
      ),
      child: _buildBody(context),
    );
  }
}
