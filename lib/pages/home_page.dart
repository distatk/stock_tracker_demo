import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stock_tracker_demo/constants/configs.dart';
import 'package:stock_tracker_demo/constants/enum.dart';
import 'package:stock_tracker_demo/constants/keys.dart';
import 'package:stock_tracker_demo/constants/queries.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';
import 'package:stock_tracker_demo/widgets/dropdown.dart';

import '../widgets/stock_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StockInfoService _stockInfoService;
  final _sectorMemoizer = AsyncMemoizer();
  late Future getSectorFuture;
  var _selectedMarket = Market.th;
  late RefreshController _refreshController;
  var _stockCount = 0;

  @override
  void initState() {
    super.initState();
    _stockInfoService = Provider.of<StockInfoService>(context, listen: false);
    _refreshController = RefreshController();
    getSectorFuture = _sectorMemoizer.runOnce(_stockInfoService.getSectors);
  }

  Widget _buildSectorDropDown() {
    return FutureBuilder(
      future: getSectorFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as List<String>;
          final dropdownEntries =
              data.map((e) => DropdownMenuEntry(value: e, label: e)).toList();
          return DropdownMenuWidget(
            key: Key('SectorDropdown'),
            label: 'Sector',
            valueList: dropdownEntries,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildDropdownSection() {
    return Row(
      key: Key('DropdownSection'),
      children: [
        Expanded(child: _buildSectorDropDown()),
        Gap(8),
        Expanded(
          child: DropdownMenuWidget(
            key: Key('MarketDropdown'),
            label: 'Market',
            valueList: Market.values.map((e) => e.dropdownMenuEntry).toList(),
            onSelected: (selectedValue) {
              if (selectedValue != null) {
                setState(() {
                  _selectedMarket = selectedValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStockList() {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getStockList),
        variables: {
          'market': _selectedMarket.requestValue,
          'limit': Configs.defaultPageSize,
          'page': 0,
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading && result.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (result.data != null) {
          var resultList = result.data![Keys.jittaRanking][Keys.data] as List;
          final stockList = resultList.map((e) => Stock.fromJson(e)).toList();
          _stockCount = resultList.length;

          return Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                refetch?.call();
                _refreshController.refreshCompleted();
              },
              onLoading: () {
                final nextPage = _stockCount ~/ Configs.defaultPageSize;
                FetchMoreOptions options = FetchMoreOptions(
                  document: gql(Queries.getStockList),
                  updateQuery: (prevRes, moreRes) {
                    final allData = [
                      ...?prevRes![Keys.jittaRanking][Keys.data],
                      ...?moreRes![Keys.jittaRanking][Keys.data],
                    ];

                    moreRes[Keys.jittaRanking][Keys.data] = allData;
                    return moreRes;
                  },
                  variables: {
                    'page': nextPage,
                    'limit': Configs.defaultPageSize,
                  },
                );
                fetchMore?.call(options);
                _refreshController.loadComplete();
              },
              child: ListView.builder(
                itemCount: stockList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StockTile(stock: stockList[index]),
                ),
              ),
            ),
          );
        }
        if (result.isLoading) {
          return Center(child: const CircularProgressIndicator());
        }

        if (result.hasException) {
          return Center(child: Text(result.exception.toString()));
        }

        if (result.data == null) {
          return Center(child: Text('something went wrong'));
        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildDropdownSection(),
            _buildStockList(),
          ],
        ),
      ),
    );
  }
}
