import 'package:flutter/material.dart';
import 'models/question.dart';
import 'set_result_page.dart';

class SetQuestionPage extends StatefulWidget {
  const SetQuestionPage({
    super.key,
    required this.level,
    required this.setNumber,
    required this.questions,
    this.onFinished,
  });

  final String level;
  final int setNumber;
  final List<Question> questions;
  final ValueChanged<int>? onFinished;

  @override
  State<SetQuestionPage> createState() => _SetQuestionPageState();
}

class _SetQuestionPageState extends State<SetQuestionPage> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  late final List<bool?> _answerStates;
  late final List<String?> _selectedStates;

  Question get _currentQuestion => widget.questions[_currentIndex];
  bool get _hasSelection => _selectedAnswer != null;
  bool get _isLast => _currentIndex == widget.questions.length - 1;
  bool get _canGoNext => _currentIndex < widget.questions.length - 1;
  bool get _canGoPrevious => _currentIndex > 0;
  bool get _canFinish => _isLast && _hasSelection;

  @override
  void initState() {
    super.initState();
    _answerStates = List<bool?>.filled(widget.questions.length, null);
    _selectedStates = List<String?>.filled(widget.questions.length, null);
  }

  void _syncSelectionForIndex() {
    _selectedAnswer = _selectedStates[_currentIndex];
    _isCorrect = _answerStates[_currentIndex];
  }

  void _checkAnswer(String selected) {
    if (_hasSelection) return;
    final cleanedSelection = selected.trim();
    final correct = _currentQuestion.answer.trim();
    final isCorrect = cleanedSelection == correct;
    setState(() {
      _selectedAnswer = cleanedSelection;
      _isCorrect = isCorrect;
      _selectedStates[_currentIndex] = cleanedSelection;
      _answerStates[_currentIndex] = isCorrect;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(isCorrect ? '정답입니다!' : '다시 도전해보세요.'),
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _goNext() {
    if (!_canGoNext) return;
    setState(() {
      _currentIndex++;
      _syncSelectionForIndex();
    });
  }

  void _goPrevious() {
    if (!_canGoPrevious) return;
    setState(() {
      _currentIndex--;
      _syncSelectionForIndex();
    });
  }

  void _finish() {
    final correctCount = _answerStates.where((e) => e != null && e).length;
    widget.onFinished?.call(correctCount);
    Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => SetResultPage(
          level: widget.level,
          setNumber: widget.setNumber,
          score: correctCount,
          total: widget.questions.length,
        ),
      ),
    ).then((score) {
      Navigator.of(context).pop(score ?? correctCount);
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
    final question = _currentQuestion;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: Text('${widget.level} 세트 ${widget.setNumber}'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _progressHeader(),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _questionCard(question),
                      const SizedBox(height: 16),
                      _optionsCard(question),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _bottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressHeader() {
    final progress = (_currentIndex + 1) / widget.questions.length;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: Color(0xFF3A7CFD)),
              const SizedBox(width: 8),
              Text(
                widget.level,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text('${_currentIndex + 1} / ${widget.questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE6ECF5),
              color: const Color(0xFF3A7CFD),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(Question question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionsCard(Question question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '선택지',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...question.options.map(_buildOption),
        ],
      ),
    );
  }

  Widget _bottomActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _canGoPrevious ? _goPrevious : null,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              side: BorderSide(color: Colors.blue.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('이전'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLast ? (_canFinish ? _finish : null) : _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A7CFD),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(_isLast ? '결과 보기' : '다음'),
          ),
        ),
      ],
    );
  }
}
