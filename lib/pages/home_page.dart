import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker_demo/constants/enum.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';
import 'package:stock_tracker_demo/widgets/dropdown.dart';

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

  @override
  void initState() {
    super.initState();
    _stockInfoService = Provider.of<StockInfoService>(context, listen: false);
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
          ),
        ),
      ],
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
          ],
        ),
      ),
    );
  }
}
