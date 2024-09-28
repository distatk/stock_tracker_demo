import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stock_tracker_demo/constants/enum.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';
import 'package:stock_tracker_demo/widgets/dropdown.dart';

import '../constants/configs.dart';
import '../utils/pagination_utils.dart';
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
  late PaginationUtils<Stock> _getStockListPaginationInstance;
  var _stockList = <Stock>[];
  bool _isFirstRefreshCompleted = false;

  @override
  void initState() {
    super.initState();
    _stockInfoService = Provider.of<StockInfoService>(context, listen: false);
    _refreshController = RefreshController();
    getSectorFuture = _sectorMemoizer.runOnce(_stockInfoService.getSectors);
    _setUpPaginationInstance();
    _onRefresh();
  }

  void _setUpPaginationInstance() {
    _getStockListPaginationInstance = PaginationUtils<Stock>(
      list: _stockList,
      callback: (page) async {
        print('callback called, page: $page');
        final paginatedStockModel = await _stockInfoService.getStockList(
          page: page,
          limit: Configs.defaultPageSize,
          market: _selectedMarket.name,
          sector: '',
        );
        return paginatedStockModel;
      },
    );
  }

  Future<void> _onRefresh() async {
    _stockList.clear();
    await _getStockListPaginationInstance.firstFetch();

    if (!_isFirstRefreshCompleted) {
      _isFirstRefreshCompleted = true;
    }
    if (!mounted) {
      return;
    }

    setState(() {});
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _getStockListPaginationInstance.loadMore();

    if (!mounted) {
      return;
    }
    setState(() {});
    _refreshController.loadComplete();
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
    return SmartRefresher(
      key: Key('TreatmentHistorySmartRefresher'),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      enablePullUp: true,
      child: _buildLoadCompleted(),
    );
  }

  Widget _buildLoadCompleted() {
    if (!_isFirstRefreshCompleted) {
      return SizedBox.shrink();
    }
    if (_stockList.isNotEmpty) {
      return ListView.builder(
        itemCount: _stockList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: StockTile(stock: _stockList[index]),
        ),
      );
    }

    return Center(
      child: Column(
        children: <Widget>[
          Icon(Icons.error_outlined,
              color: Theme.of(context).colorScheme.error),
          const Text('No stock data found'),
        ],
      ),
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
            Expanded(child: _buildStockList()),
          ],
        ),
      ),
    );
  }
}
