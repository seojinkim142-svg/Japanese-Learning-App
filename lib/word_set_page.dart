import 'dart:math';

import 'package:flutter/material.dart';
import 'models/question.dart';
import 'services/voca_service.dart';
import 'set_question_page.dart';

class WordSetPage extends StatefulWidget {
  const WordSetPage({super.key, required this.level});

  final String level;

  @override
  State<WordSetPage> createState() => _WordSetPageState();
}

class _WordSetPageState extends State<WordSetPage> {
  final VocaService _vocaService = VocaService();
  late Future<List<List<Question>>> _setsFuture;
  final Map<int, int> _scores = {}; // setNumber -> score

  @override
  void initState() {
    super.initState();
    _setsFuture = _loadSets();
  }

  Future<List<List<Question>>> _loadSets() async {
    if (widget.level != 'JLPT N5') {
      return [];
    }
    final entries = await _vocaService.loadVoca();
    if (entries.isEmpty) return [];

    final random = Random();
    final shuffled = [...entries]..shuffle(random);

    // 최소 50개 확보: 부족하면 순환해서 채움
    while (shuffled.length < 50) {
      shuffled.addAll(entries);
    }
    final selected = shuffled.take(50).toList();

    final sets = <List<Question>>[];
    for (var i = 0; i < 10; i++) {
      final slice = selected.skip(i * 5).take(5).toList();
      final questions = slice.map((e) => _toQuestion(e, entries, random)).toList();
      sets.add(questions);
    }
    return sets;
  }

  Question _toQuestion(VocaEntry entry, List<VocaEntry> pool, Random random) {
    final correct = entry.meaning;
    final others = <String>{};
    while (others.length < 3) {
      final pick = pool[random.nextInt(pool.length)].meaning;
      if (pick != correct) {
        others.add(pick);
      }
    }
    final options = [correct, ...others]..shuffle(random);
    return Question(
      text: entry.word,
      question: '뜻이 무엇인가요?',
      options: options,
      answer: correct,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level} 단어 세트'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<List<Question>>>(
        future: _setsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final sets = snapshot.data ?? [];
          if (widget.level != 'JLPT N5') {
            return _comingSoon();
          }
          if (sets.isEmpty) {
            return const Center(child: Text('세트를 불러오지 못했습니다.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.6,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              final setNumber = index + 1;
              final questions = sets[index];
              return _setCard(context, setNumber, questions);
            },
          );
        },
      ),
    );
  }

  Widget _setCard(BuildContext context, int setNumber, List<Question> questions) {
    final score = _scores[setNumber];
    final status = score != null ? '완료 $score/${questions.length}' : '5문제 세트';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Text('$setNumber', style: const TextStyle(color: Colors.blue)),
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

  Widget _comingSoon() {
    return const Center(
      child: Text('해당 레벨의 단어 문제는 준비 중입니다.'),
    );
  }
}

