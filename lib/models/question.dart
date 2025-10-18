class Question {
  final String question;
  final String? image;
  final String? audio;
  final List<String> options;
  final String answer;

  Question({
    required this.question,
    this.image,
    this.audio,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      image: json['image'],
      audio: json['audio'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }
}
