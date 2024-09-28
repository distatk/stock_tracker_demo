import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StockRatingWidget extends StatelessWidget {
  const StockRatingWidget({required this.rating, super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        // RadialAxis(showAxisLine: false),
        RadialAxis(
          showTicks: false,
          showLabels: false,
          minimum: 0,
          maximum: 10,
          pointers: <GaugePointer>[
            RangePointer(
              value: rating,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFFCC2B5E), Color(0xFF753A88)],
                  stops: <double>[0.25, 0.75]),
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(rating.toStringAsFixed(2)),
            ),
          ],
        ),
      ],
    );
  }
}
