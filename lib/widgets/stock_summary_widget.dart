import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StockSummaryWidget extends StatefulWidget {
  const StockSummaryWidget({required this.summaryText, super.key});

  final String summaryText;

  @override
  State<StockSummaryWidget> createState() => _StockSummaryWidgetState();
}

class _StockSummaryWidgetState extends State<StockSummaryWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _iconTurns;
  late AnimationController _animationController;
  late CurvedAnimation _heightFactor;
  bool _isExpanded = false;
  bool _shouldShowGradient = true;

  final Tween<double> _heightFactorTween = Tween<double>(begin: 0.4, end: 1.0);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _heightFactor = CurvedAnimation(
      parent: _animationController.drive(_heightFactorTween),
      curve: Curves.easeIn,
    );
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
  }

  void _toggleExpansion() async {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
    setState(() {
      _shouldShowGradient = !_isExpanded;
    });
  }

  Widget _buildText(summaryText) {
    return Text(
      summaryText,
      key: Key('SummaryText'),
      overflow: TextOverflow.fade,
    );
  }

  Widget _buildButtonRow() {
    return Row(
      key: Key('ButtonRow'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransition(
          turns: _iconTurns,
          child: const Icon(Icons.expand_more, color: Colors.black38),
        ),
        Gap(8),
        Text(
          _isExpanded ? 'Hide' : 'Show more',
          style: TextStyle(color: Colors.black38),
        ),
      ],
    );
  }

  Widget _buildAnimationWidget() {
    return AnimatedBuilder(
      key: Key('AnimationSection'),
      animation: _animationController.view,
      builder: (context, _) {
        return Stack(
          children: [
            ClipRect(
              clipBehavior: Clip.hardEdge,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: _buildText(widget.summaryText),
              ),
            ),
            if (_shouldShowGradient)
              Positioned.fill(
                key: Key('Gradient'),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.25, 1],
                      colors: [Colors.white, Colors.white.withOpacity(0.0)],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            key: Key('Title'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Gap(8),
          _buildAnimationWidget(),
          Gap(8),
          _buildButtonRow()
        ],
      ),
    );
  }
}
