enum FlashcardType {
  concept,
  diagram,
  question,
}

class Flashcard {
  final String id;
  final String topicId;
  final FlashcardType type;
  final String title;
  final String content;
  final String? imageUrl;
  final String? answer;
  bool isCompleted;

  Flashcard({
    required this.id,
    required this.topicId,
    required this.type,
    required this.title,
    required this.content,
    this.imageUrl,
    this.answer,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'topicId': topicId,
        'type': type.toString().split('.').last,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'answer': answer,
        'isCompleted': isCompleted,
      };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
        id: json['id'] as String,
        topicId: json['topicId'] as String,
        type: FlashcardType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
        ),
        title: json['title'] as String,
        content: json['content'] as String,
        imageUrl: json['imageUrl'] as String?,
        answer: json['answer'] as String?,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
