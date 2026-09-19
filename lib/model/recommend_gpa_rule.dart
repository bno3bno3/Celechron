/// 推免绩点规则
///
/// 推免绩点 = majorRatio × 主修均绩 + overallRatio × 加权总均绩，
/// 其中加权总均绩里主修课的绩点先乘以 majorWeight（单门覆盖优先）。
/// 默认值下推免绩点等于原始五分制均绩。
class RecommendGpaRule {
  static const double maxMajorWeight = 2.0;

  final double majorWeight;
  final double majorRatio;
  final double overallRatio;

  const RecommendGpaRule({
    this.majorWeight = 1.0,
    this.majorRatio = 0.0,
    this.overallRatio = 1.0,
  });

  static double clampWeight(double v) =>
      v.isNaN || v <= 0 ? 1.0 : (v > maxMajorWeight ? maxMajorWeight : v);

  static double clampRatio(double v) =>
      v.isNaN ? 0.0 : (v < 0 ? 0.0 : (v > 1 ? 1.0 : v));

  RecommendGpaRule copyWith({
    double? majorWeight,
    double? majorRatio,
    double? overallRatio,
  }) =>
      RecommendGpaRule(
        majorWeight: clampWeight(majorWeight ?? this.majorWeight),
        majorRatio: clampRatio(majorRatio ?? this.majorRatio),
        overallRatio: clampRatio(overallRatio ?? this.overallRatio),
      );

  Map<String, double> toMap() => {
        'majorWeight': majorWeight,
        'majorRatio': majorRatio,
        'overallRatio': overallRatio,
      };

  factory RecommendGpaRule.fromMap(Map? map) {
    if (map == null) return const RecommendGpaRule();
    double read(String key, double fallback) {
      var v = map[key];
      return v is num ? v.toDouble() : fallback;
    }

    return RecommendGpaRule(
      majorWeight: clampWeight(read('majorWeight', 1.0)),
      majorRatio: clampRatio(read('majorRatio', 0.0)),
      overallRatio: clampRatio(read('overallRatio', 1.0)),
    );
  }
}
