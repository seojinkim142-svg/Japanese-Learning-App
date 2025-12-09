import 'package:flutter/material.dart';
import 'user_page.dart';
import 'all_reading_page.dart';
import 'word_level_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF0FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _header(theme, context),
              const SizedBox(height: 12),
              _progressCard(),
              const SizedBox(height: 16),
              _hotOffers(context),
              const SizedBox(height: 16),
              _todoList(context),
              const SizedBox(height: 16),
              _milestoneCard(
                title: '다음 목표',
                badge: '높음',
                color: Colors.black,
              ),
              const SizedBox(height: 12),
              _milestoneCard(
                title: '다가오는 목표',
                badge: '보통',
                color: const Color(0xFF3A7CFD),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(ThemeData theme, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const UserPage()),
        );
      },
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요, 학습자님',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '오늘도 한 걸음 성장해요',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _progressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: Color(0xFF3A7CFD)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('진행도', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('학습 진행률을 확인하세요'),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '67%',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text('12 문제 완료'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hotOffers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🔥 집중 코스', style: TextStyle(fontWeight: FontWeight.w800)),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('더보기')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _offerCard(
              label: '단어 런치 부스트',
              color: const Color(0xFFF5F0FF),
              icon: Icons.flash_on,
            ),
            _offerCard(
              label: '단어 문제',
              color: const Color(0xFF1E1E2C),
              icon: Icons.translate,
              badge: 'NEW',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WordLevelPage()),
                );
              },
            ),
            _offerCard(
              label: '독해 플로우',
              color: const Color(0xFFEFF5FF),
              icon: Icons.menu_book,
            ),
          ],
        ),
      ],
    );
  }

  Widget _offerCard({
    required String label,
    required Color color,
    required IconData icon,
    String? badge,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
          height: 110,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.black87),
                ),
              ),
              if (badge != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  label,
                  style: TextStyle(
                    color: color.computeLuminance() < 0.5 ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _todoList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('To Do List', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: Icon(Icons.people, size: 16, color: Colors.black87),
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('편집')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _todoTile(
              title: '전체',
              color: Colors.white,
              textColor: Colors.black87,
              icon: Icons.timer,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AllReadingPage()),
                );
              },
            ),
            const SizedBox(width: 8),
            _todoTile(
              title: '예정',
              color: const Color(0xFFF9D266),
              textColor: Colors.black87,
              icon: Icons.calendar_today,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _todoTile(
              title: '진행중',
              color: const Color(0xFFD7E5FF),
              textColor: Colors.black87,
              icon: Icons.play_circle_fill,
            ),
            const SizedBox(width: 8),
            _todoTile(
              title: '미완료',
              color: const Color(0xFFF2C8FF),
              textColor: Colors.black87,
              icon: Icons.error_outline,
            ),
          ],
        ),
      ],
    );
  }

  Widget _todoTile({
    required String title,
    required Color color,
    required Color textColor,
    required IconData icon,
    void Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: textColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _milestoneCard({
    required String title,
    required String badge,
    required Color color,
  }) {
    final bgColor = color == Colors.black ? const Color(0xFF111111) : color;
    const textColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.attach_file, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                '첨부: 4개',
                style: TextStyle(color: textColor),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text('John Doe', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
