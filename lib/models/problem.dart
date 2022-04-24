import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../constants.dart';

class Problem {
  final int id;
  final String name;
  final double acceptance;
  final String difficulty;
  final String questionHtml;
  final String solutionHtml;
  final List<String>? tags;
  final List<String>? companies;
  String? status;
  String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Problem({
    required this.id,
    required this.name,
    required this.acceptance,
    required this.difficulty,
    required this.questionHtml,
    required this.solutionHtml,
    required this.tags,
    required this.companies,
    this.status,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  // from json
  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as int,
      name: json['name'] as String,
      acceptance: json['acceptance'] as double,
      difficulty: json['difficulty'] as String,
      questionHtml: json['question_html'] as String,
      solutionHtml: json['solution_html'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      companies:
          (json['companies'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String?,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'acceptance': acceptance,
      'difficulty': difficulty,
      'question_html': questionHtml,
      'solution_html': solutionHtml,
      'tags': tags,
      'companies': companies,
      'status': status,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

Future<Problem> problemFromHttp(int id) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String accessToken = _prefs.getString('access_token') ?? '';
  http.Response response =
      await http.get(Uri.parse("$api/api/products/$id/"), headers: {
    'Authorization': 'Bearer $accessToken',
  });
  if (response.statusCode == 200) {
    return Problem.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load product');
  }
}

Future<List<Problem>> problemsFromDB() async {
  final Database db = await databaseFactoryIo.openDatabase(dbPath);
  final StoreRef<int, Map<String, dynamic>> store =
      StoreRef<int, Map<String, dynamic>>(DBName.problems);
  final List<RecordSnapshot<int, Map<String, dynamic>>> records =
      await store.find(db);
  return records.map((record) => Problem.fromJson(record.value)).toList();
}

Future<Problem> problemFromDB(int id) async {
  final Database db = await databaseFactoryIo.openDatabase(dbPath);
  final StoreRef<int, Map<String, dynamic>> store =
      StoreRef<int, Map<String, dynamic>>(DBName.problems);
  final Map<String, dynamic>? record = await store.record(id).get(db);
  // check if record is null
  if (record == null) {
    throw Exception('Record not found');
  } else {
    return Problem.fromJson(record);
  }
}

Future<void> saveProblemToDB(Problem problem) async {
  final Database db = await databaseFactoryIo.openDatabase(dbPath);
  final StoreRef<int, Map<String, dynamic>> store =
      StoreRef<int, Map<String, dynamic>>(DBName.problems);
  await store.record(problem.id).put(db, problem.toJson());
}
