import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('학습자님', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('오늘도 한 걸음 성장해요', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.book),
            title: Text('학습 진행도'),
            subtitle: Text('최근 학습: JLPT N5'),
            trailing: Text('67%'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text('뱃지'),
            subtitle: Text('새로운 뱃지를 모아보세요'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('설정'),
            subtitle: Text('알림, 테마, 언어'),
          ),
        ],
      ),
    );
  }
}

