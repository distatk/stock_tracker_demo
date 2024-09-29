class Ranking {
  const Ranking({required this.rank, required this.totalMember});

  final int rank;
  final int totalMember;

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      rank: json['rank'] as int,
      totalMember: json['member'] as int,
    );
  }
}
