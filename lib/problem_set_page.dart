import 'package:flutter/material.dart';
import 'services/question_service.dart';
import 'set_question_page.dart';

class ProblemSetPage extends StatefulWidget {
  const ProblemSetPage({super.key, required this.level});

  final String level;

  @override
  State<ProblemSetPage> createState() => _ProblemSetPageState();
}

class _ProblemSetPageState extends State<ProblemSetPage> {
  final Map<int, int> _scores = {}; // setNumber -> score

  // 25행 2열 = 50개 카드 표시
  int get _itemCount => 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level} 문제 세트'),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.8,
        ),
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          final setNumber = index + 1;
          return _setCard(context, setNumber);
        },
      ),
    );
  }

  Widget _setCard(BuildContext context, int setNumber) {
    final score = _scores[setNumber];
    final offset = (setNumber - 1) * 10;
    final status = score != null ? '완료 $score/10' : '10문제 세트';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final service = QuestionService();
        final questions = await service.loadQuestionsSlice(
          startIndex: offset,
          count: 10,
        );
        if (!mounted) return;
        if (questions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('해당 세트는 준비 중입니다.')),
          );
          return;
        }
        Navigator.of(context)
            .push<int>(
          MaterialPageRoute(
            builder: (_) => SetQuestionPage(
              level: widget.level,
              setNumber: setNumber,
              questions: questions,
              onFinished: (value) {
                setState(() {
                  _scores[setNumber] = value;
                });
              },
            ),
          ),
        )
            .then((value) {
          if (value != null) {
            setState(() {
              _scores[setNumber] = value;
            });
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade50,
              child: Text(
                '$setNumber',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                status,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
