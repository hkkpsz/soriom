import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/answer_option.dart';
import '../widgets/answer_button.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final String mainCategory;
  final String subCategory;

  const QuizScreen({
    super.key,
    required this.mainCategory,
    required this.subCategory,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int totalQuestions = 10;
  String? selectedAnswer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int remainingTime = 5;
  List<Question> questions = [];
  bool isLoading = true;
  int score = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      List<Question> allQuestions = await QuizService.loadQuestions(
        widget.mainCategory,
        widget.subCategory,
      );

      // Soruları karıştır ve 10 tanesini seç
      allQuestions.shuffle(Random());
      setState(() {
        questions = allQuestions.take(totalQuestions).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    if (selectedAnswer == questions[currentQuestionIndex].answer) {
      score++;
    }

    // Ses çalıyorsa durdur
    if (isPlaying) {
      _audioPlayer.stop();
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showAnswer = false;
        isPlaying = false;
      });
    } else {
      // Quiz bitti, sonuç ekranına git
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Tamamlandı!'),
        content: Text('Skorunuz: $score/${questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Ana Menüye Dön'),
          ),
        ],
      ),
    );
  }

  void _showAudioError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text('Sorular yüklenemedi', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / totalQuestions,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${currentQuestionIndex + 1}/$totalQuestions',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: widget.mainCategory == 'Müzik'
          ? _buildMusicQuiz(currentQuestion)
          : _buildPhotoQuiz(currentQuestion),
    );
  }

  Widget _buildPhotoQuiz(Question questionData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            questionData.question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: questionData.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      questionData.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(Icons.image, size: 80, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ...questionData.options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            String label = String.fromCharCode(65 + index); // A, B, C, D

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerOption(
                label: label,
                text: option,
                isSelected: selectedAnswer == option,
                isCorrect: showAnswer && option == questionData.answer,
                onTap: selectedAnswer == null
                    ? () {
                        setState(() {
                          selectedAnswer = option;
                          showAnswer = true;
                        });
                      }
                    : () {},
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Bitir'
                    : 'Sonraki Soru',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicQuiz(Question questionData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            questionData.question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () async {
              if (isPlaying) {
                await _audioPlayer.pause();
                setState(() {
                  isPlaying = false;
                });
              } else {
                // Ses dosyası çal
                // Ses dosyası çal - Boş dosyalar için güvenli mod
                if (questionData.audio != null) {
                  try {
                    String audioPath = questionData.audio!.replaceFirst(
                      'assets/',
                      '',
                    );

                    // Gerçek ses dosyası çal
                    await _audioPlayer.play(AssetSource(audioPath));
                    setState(() {
                      isPlaying = true;
                    });
                  } catch (e) {
                    print('Ses dosyası hatası: $e');
                    _showAudioError('Ses dosyası çalınamadı');
                  }
                } else {
                  _showAudioError('Ses dosyası bulunamadı');
                }
              }
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            questionData.audio != null ? '00:05' : 'Ses Yok',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            questionData.audio != null
                ? 'Şarkıyı dinleyin'
                : 'Ses dosyası bulunamadı',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: AnswerButton(
                  text: questionData.options[0],
                  isSelected: selectedAnswer == questionData.options[0],
                  isCorrect: questionData.options[0] == questionData.answer,
                  showAnswer: showAnswer,
                  onTap: () {
                    if (selectedAnswer == null) {
                      setState(() {
                        selectedAnswer = questionData.options[0];
                        showAnswer = true;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnswerButton(
                  text: questionData.options[1],
                  isSelected: selectedAnswer == questionData.options[1],
                  isCorrect: questionData.options[1] == questionData.answer,
                  showAnswer: showAnswer,
                  onTap: () {
                    if (selectedAnswer == null) {
                      setState(() {
                        selectedAnswer = questionData.options[1];
                        showAnswer = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AnswerButton(
                  text: questionData.options[2],
                  isSelected: selectedAnswer == questionData.options[2],
                  isCorrect: questionData.options[2] == questionData.answer,
                  showAnswer: showAnswer,
                  onTap: () {
                    if (selectedAnswer == null) {
                      setState(() {
                        selectedAnswer = questionData.options[2];
                        showAnswer = true;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnswerButton(
                  text: questionData.options[3],
                  isSelected: selectedAnswer == questionData.options[3],
                  isCorrect: questionData.options[3] == questionData.answer,
                  showAnswer: showAnswer,
                  onTap: () {
                    if (selectedAnswer == null) {
                      setState(() {
                        selectedAnswer = questionData.options[3];
                        showAnswer = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedAnswer != null ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Bitir'
                    : 'Sonrakı',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
