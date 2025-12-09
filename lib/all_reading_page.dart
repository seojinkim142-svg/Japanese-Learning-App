import 'package:flutter/material.dart';
import 'problem_set_page.dart';

class AllReadingPage extends StatelessWidget {
  const AllReadingPage({super.key});

  static const _levels = ['JLPT N1', 'JLPT N2', 'JLPT N3', 'JLPT N4', 'JLPT N5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 독해 문제'),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
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
          MaterialPageRoute(builder: (_) => ProblemSetPage(level: level)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.menu_book, color: Colors.blue),
            ),
            Text(
              level,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Text('50문제 세트 제공', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

