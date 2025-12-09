import 'package:flutter/services.dart';
import '../models/question.dart';
import 'package:csv/csv.dart';

class QuestionService {
  Future<List<Question>> loadQuestions() async {
    final raw = await rootBundle.loadString('assets/JLPT_N5.csv');
    final rows = const CsvToListConverter(eol: '\n').convert(raw);

    // 첫 줄이 헤더인 경우 제외
    final data = rows.skip(1).toList();

    // 7개 컬럼: text, question, option1~4, answer
    return data.map((row) {
      return Question(
        text: row[0].toString().trim(),
        question: row[1].toString().trim(),
        options: [
          row[2].toString().trim(),
          row[3].toString().trim(),
          row[4].toString().trim(),
          row[5].toString().trim(),
        ],
        answer: row[6].toString().trim(),
      );
    }).toList();
  }

  Future<List<Question>> loadQuestionsSlice({
    required int startIndex,
    required int count,
  }) async {
    final all = await loadQuestions();
    if (startIndex < 0 || startIndex >= all.length) return [];
    final end = (startIndex + count).clamp(0, all.length);
    return all.sublist(startIndex, end);
  }
}
