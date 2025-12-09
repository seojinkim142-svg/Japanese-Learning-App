import 'package:flutter/material.dart';
import 'word_set_page.dart';

class WordLevelPage extends StatelessWidget {
  const WordLevelPage({super.key});

  static const _levels = ['JLPT N1', 'JLPT N2', 'JLPT N3', 'JLPT N4', 'JLPT N5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 문제 레벨 선택'),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
        ),
        itemCount: _levels.length,
        itemBuilder: (context, index) {
          final level = _levels[index];
          return _levelCard(context, level);
        },
      ),
    );
  }

  Widget _levelCard(BuildContext context, String level) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => WordSetPage(level: level)),
        );
      },
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.translate, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                level,
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

