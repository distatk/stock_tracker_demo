import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stock_tracker_demo/data_models/price_history.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants/enum.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({
    required this.currency,
    this.priceHistory = const [],
    super.key,
  });

  final List<PriceHistory> priceHistory;

  final String currency;

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with SingleTickerProviderStateMixin {
  late DateTime now;
  late DateTime minimumDateTime;
  var interval = StockChartInterval.year;
  late TabController _tabController;
  late TrackballBehavior _trackballBehavior;
  late ValueNotifier<double> _priceNotifier;

  @override
  void initState() {
    super.initState();
    final dateTimeNow = DateTime.now();
    now = DateTime(dateTimeNow.year, dateTimeNow.month, 1);
    minimumDateTime = now.subtract(interval.duration);
    _tabController = TabController(length: 5, vsync: this, initialIndex: 1);
    _priceNotifier = ValueNotifier(widget.priceHistory.first.value);
    _trackballBehavior = TrackballBehavior(
      enable: true,
      tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        format: 'point.x',
      ),
    );
  }

  Widget _buildIntervalSelector() {
    return TabBar(
      tabs: StockChartInterval.values.map((e) => Tab(text: e.label)).toList(),
      controller: _tabController,
      labelPadding: EdgeInsets.symmetric(horizontal: 4),
      indicator: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerHeight: 0,
      onTap: (index) {
        setState(() {
          interval = StockChartInterval.values[index];
          minimumDateTime = now.subtract(interval.duration);
        });
      },
    );
  }

  Widget _buildPriceText() {
    return ValueListenableBuilder<double>(
      valueListenable: _priceNotifier,
      builder: (context, value, _) {
        var textColor = Theme.of(context).colorScheme.primary;
        if (value > widget.priceHistory.first.value) {
          textColor = Colors.green;
        } else if (value < widget.priceHistory.first.value) {
          textColor = Colors.red;
        }
        return Text(
          '${value.toStringAsFixed(2)} ${widget.currency}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceText(),
        Gap(8),
        SfCartesianChart(
          trackballBehavior: _trackballBehavior,
          onTrackballPositionChanging: (trackballArgs) {
            if (trackballArgs.chartPointInfo.chartPoint?.y != null) {
              _priceNotifier.value =
                  trackballArgs.chartPointInfo.chartPoint!.y!.toDouble();
            }
          },
          onChartTouchInteractionUp: (chartTouchInteractionArgs) {
            _priceNotifier.value = widget.priceHistory.first.value;
          },
          primaryXAxis: DateTimeAxis(
            maximum: DateTime.now(),
            minimum: minimumDateTime,
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            intervalType: DateTimeIntervalType.months,
            isVisible: false,
          ),
          series: <CartesianSeries>[
            LineSeries<PriceHistory, DateTime>(
              animationDuration: 0,
              dataSource: widget.priceHistory,
              xValueMapper: (priceHistory, _) => priceHistory.datetime,
              yValueMapper: (priceHistory, _) => priceHistory.value,
            )
          ],
        ),
        _buildIntervalSelector(),
      ],
    );
  }
}
