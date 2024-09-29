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

  factory Factor.fromJson(Map<String, dynamic> json) {
    return Factor(
      growthFactor: json['growth'] == null
          ? null
          : FactorValue.fromJson(json['growth'] as Map<String, dynamic>),
      recentFactor: json['recent'] == null
          ? null
          : FactorValue.fromJson(json['recent'] as Map<String, dynamic>),
      financialFactor: json['financial'] == null
          ? null
          : FactorValue.fromJson(json['financial'] as Map<String, dynamic>),
      managementFactor: json['management'] == null
          ? null
          : FactorValue.fromJson(json['management'] as Map<String, dynamic>),
      returnFactor: json['return'] == null
          ? null
          : FactorValue.fromJson(json['return'] as Map<String, dynamic>),
    );
  }
}
