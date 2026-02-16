class StudySession {
  final String topicId;
  final DateTime startTime;
  DateTime? endTime;
  int cardsViewed;

  StudySession({
    required this.topicId,
    required this.startTime,
    this.endTime,
    this.cardsViewed = 0,
  });

  int get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inSeconds;
  }

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'cardsViewed': cardsViewed,
      };

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
        topicId: json['topicId'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'] as String)
            : null,
        cardsViewed: json['cardsViewed'] as int? ?? 0,
      );
}
