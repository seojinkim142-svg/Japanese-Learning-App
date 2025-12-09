import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class VocaEntry {
  VocaEntry({required this.category, required this.word, required this.meaning});
  final String category;
  final String word;
  final String meaning;
}

class VocaService {
  Future<List<VocaEntry>> loadVoca() async {
    final raw = await rootBundle.loadString('assets/voca.csv');
    final rows = const CsvToListConverter(eol: '\n').convert(raw);
    final data = rows.skip(1); // 헤더 제외
    return data
        .map((row) => VocaEntry(
              category: row[0].toString().trim(),
              word: row[1].toString().trim(),
              meaning: row[2].toString().trim(),
            ))
        .toList();
  }
}

