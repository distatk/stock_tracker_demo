import 'package:flutter/material.dart';

class DropdownMenuWidget<T> extends StatefulWidget {
  const DropdownMenuWidget({
    required this.valueList,
    this.label,
    this.onSelected,
    super.key,
  });

  final List<DropdownMenuEntry<T>> valueList;

  final String? label;

  final ValueChanged<T?>? onSelected;

  @override
  State<DropdownMenuWidget<T>> createState() => _DropdownMenuWidgetState<T>();
}

class _DropdownMenuWidgetState<T> extends State<DropdownMenuWidget<T>> {
  late T? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.valueList.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      width: double.infinity,
      label: widget.label != null ? Text(widget.label!) : null,
      initialSelection: widget.valueList.first.value,
      onSelected: widget.onSelected ??
          (T? value) {
            setState(() {
              dropdownValue = value;
            });
          },
      dropdownMenuEntries: widget.valueList,
    );
  }
}
