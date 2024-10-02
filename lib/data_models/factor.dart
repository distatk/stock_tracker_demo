class FactorValue {
  const FactorValue({
    required this.name,
    required this.level,
    required this.value,
  });

  final String name;
  final String level;
  final int value;

  factory FactorValue.fromJson(Map<String, dynamic> json) {
    return FactorValue(
      name: json['name'] as String,
      level: json['level'] as String,
      value: json['value'] as int,
    );
  }
}

class Factor {
  const Factor({
    this.growthFactor,
    this.recentFactor,
    this.financialFactor,
    this.managementFactor,
    this.returnFactor,
  });

  final FactorValue? growthFactor;
  final FactorValue? recentFactor;
  final FactorValue? financialFactor;
  final FactorValue? managementFactor;
  final FactorValue? returnFactor;

  List<FactorValue> get values => [
        if (growthFactor != null) growthFactor!,
        if (recentFactor != null) recentFactor!,
        if (financialFactor != null) financialFactor!,
        if (managementFactor != null) managementFactor!,
        if (returnFactor != null) returnFactor!,
      ];

  factory Factor.fromJson(Map<String, dynamic> json) {
    return Factor(
      growthFactor: json['value']['growth'] == null
          ? null
          : FactorValue.fromJson(
              json['value']['growth'] as Map<String, dynamic>),
      recentFactor: json['value']['recent'] == null
          ? null
          : FactorValue.fromJson(
              json['value']['recent'] as Map<String, dynamic>),
      financialFactor: json['value']['financial'] == null
          ? null
          : FactorValue.fromJson(
              json['value']['financial'] as Map<String, dynamic>),
      managementFactor: json['value']['management'] == null
          ? null
          : FactorValue.fromJson(
              json['value']['management'] as Map<String, dynamic>),
      returnFactor: json['value']['return'] == null
          ? null
          : FactorValue.fromJson(
              json['value']['return'] as Map<String, dynamic>),
    );
  }
}
