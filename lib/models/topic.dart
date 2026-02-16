class Topic {
  final String id;
  final String title;
  final DateTime createdAt;
  DateTime lastStudied;
  final int totalCards;
  int completedCards;
  int totalStudyTime; // in seconds

  Topic({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastStudied,
    required this.totalCards,
    this.completedCards = 0,
    this.totalStudyTime = 0,
  });

  double get completionPercentage =>
      totalCards > 0 ? (completedCards / totalCards) * 100 : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'lastStudied': lastStudied.toIso8601String(),
        'totalCards': totalCards,
        'completedCards': completedCards,
        'totalStudyTime': totalStudyTime,
      };

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastStudied: DateTime.parse(json['lastStudied'] as String),
        totalCards: json['totalCards'] as int,
        completedCards: json['completedCards'] as int? ?? 0,
        totalStudyTime: json['totalStudyTime'] as int? ?? 0,
      );
}
