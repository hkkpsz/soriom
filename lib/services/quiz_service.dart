import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizService {
  static Future<List<Question>> loadQuestions(
    String category,
    String subCategory,
  ) async {
    try {
      String jsonPath = _getJsonPath(category, subCategory);
      String jsonString = await rootBundle.loadString(jsonPath);
      List<dynamic> jsonList = json.decode(jsonString);

      return jsonList
          .map((json) => _shuffleOptions(Question.fromJson(json)))
          .toList();
    } catch (e) {
      print('Error loading questions: $e');
      return _getDefaultQuestions(category, subCategory);
    }
  }

  static String _getJsonPath(String category, String subCategory) {
    switch (category) {
      case 'Fotoğraf':
        switch (subCategory) {
          case 'Futbol':
            return 'assets/data/futbolcu_sorulari.json';
          case 'Genel Kültür':
            return 'assets/data/genel_kultur_sorulari.json';
          default:
            return 'assets/data/futbolcu_sorulari.json';
        }
      case 'Müzik':
        switch (subCategory) {
          case 'Arabesk':
            return 'assets/data/arabesk_sorulari.json';
          case 'Pop':
            return 'assets/data/pop_sorulari.json';
          case 'Rap':
            return 'assets/data/rap_sorulari.json';
          default:
            return 'assets/data/arabesk_sorulari.json';
        }

      default:
        return 'assets/data/futbolcu_sorulari.json';
    }
  }

  static Question _shuffleOptions(Question question) {
    // Seçenekleri karıştır
    List<String> shuffledOptions = List.from(question.options);
    shuffledOptions.shuffle(Random());

    return Question(
      question: question.question,
      image: question.image,
      audio: question.audio,
      options: shuffledOptions,
      answer: question.answer, // Doğru cevap aynı kalır
    );
  }

  static List<Question> _getDefaultQuestions(
    String category,
    String subCategory,
  ) {
    // Fallback sorular
    return [
      Question(
        question: 'Bu futbolcu kimdir?',
        image: 'assets/images/futbolcular/default.jpg',
        options: ['Seçenek A', 'Seçenek B', 'Seçenek C', 'Seçenek D'],
        answer: 'Seçenek A',
      ),
    ];
  }
}
