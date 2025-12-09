import 'package:flutter/material.dart';
import 'models/question.dart';
import 'services/question_service.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final QuestionService _questionService = QuestionService();

  List<Question> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;

  Question get _currentQuestion => _questions[_currentIndex];
  bool get _hasSelection => _selectedAnswer != null;
  bool get _canGoNext => _currentIndex < _questions.length - 1;
  bool get _canGoPrevious => _currentIndex > 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _questionService.loadQuestions();
    if (!mounted) return;
    setState(() {
      _questions = questions;
      _resetSelection();
    });
  }

  void _resetSelection() {
    _selectedAnswer = null;
    _isCorrect = null;
  }

  void _checkAnswer(String selected) {
    if (_hasSelection) return;

    final correctAnswer = _currentQuestion.answer.trim();
    final cleanedSelection = selected.trim();
    final isCorrect = cleanedSelection == correctAnswer;

    setState(() {
      _selectedAnswer = cleanedSelection;
      _isCorrect = isCorrect;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(isCorrect ? '정답입니다!' : '아쉽습니다. 다시 도전해보세요.'),
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _goToNext() {
    if (!_canGoNext) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _currentIndex++;
      _resetSelection();
    });
  }

  void _goToPrevious() {
    if (!_canGoPrevious) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _currentIndex--;
      _resetSelection();
    });
  }

  Color? _optionColor(String option) {
    if (_selectedAnswer != option) return null;
    if (_isCorrect == null) return null;
    return _isCorrect! ? Colors.green.shade100 : Colors.red.shade100;
  }

  Widget _buildOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _optionColor(option)),
        onPressed: () => _checkAnswer(option),
        child: Text(option),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JLPT N5 단어 학습'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...question.options.map(_buildOption),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _canGoPrevious ? _goToPrevious : null,
                  child: const Text('이전 문제'),
                ),
                Text('${_currentIndex + 1}/${_questions.length}'),
                ElevatedButton(
                  onPressed: _canGoNext ? _goToNext : null,
                  child: const Text('다음 문제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

