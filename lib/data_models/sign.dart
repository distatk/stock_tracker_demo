import 'package:stock_tracker_demo/constants/enum.dart';

class Sign {
  const Sign({
    required this.title,
    required this.type,
    required this.value,
  });

  final String title;
  final SignType type;
  final String value;

  factory Sign.fromJson(Map<String, dynamic> json) {
    return Sign(
      title: json['title'],
      type: SignType.values.byName(json['type']),
      value: json['value'],
    );
  }
}
