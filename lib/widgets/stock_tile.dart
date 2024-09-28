import 'package:flutter/material.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';

class StockTile extends StatelessWidget {
  const StockTile({required this.stock, super.key});

  final Stock stock;

  Widget _buildRanking() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        stock.rank.toString(),
        key: Key('Ranking'),
      ),
    );
  }

  Widget _buildNameAndSubtitle() {
    return Column(
      key: Key('NameAndSubtitle'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          stock.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          stock.id,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Row(
      key: Key('Body'),
      children: [
        _buildRanking(),
        Expanded(child: _buildNameAndSubtitle()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(stock.jittaScore.toString()),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            offset: Offset(4, 4), // changes position of shadow
          ),
        ],
      ),
      child: _buildBody(),
    );
  }
}
