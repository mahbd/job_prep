import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../constants.dart';

class Problem {
  final int id;
  final String name;
  String? status;
  final double acceptance;
  final String difficulty;
  final String questionHtml;
  final String solutionHtml;
  final List<String>? tags;
  final List<String>? companies;

  Problem({
    required this.id,
    required this.name,
    this.status,
    required this.acceptance,
    required this.difficulty,
    required this.questionHtml,
    required this.solutionHtml,
    required this.tags,
    required this.companies,
  });

  // from json
  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String?,
      acceptance: double.parse(json['acceptance']),
      difficulty: json['difficulty'] as String,
      questionHtml: json['question_html'] as String,
      solutionHtml: json['solution_html'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      companies:
          (json['companies'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'acceptance': acceptance,
      'difficulty': difficulty,
      'question_html': questionHtml,
      'solution_html': solutionHtml,
      'tags': tags,
      'companies': companies,
    };
  }
}

Future<Problem> problemFromHttp(int id) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String accessToken = _prefs.getString('access') ?? '';
  http.Response response =
      await http.get(Uri.parse("$api/problems/$id/"), headers: {
    'Authorization': 'Bearer $accessToken',
  });
  if (response.statusCode == 200) {
    return Problem.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load product');
  }
}

Future<List<Problem>> problemsFromHttp() async {
  List<Problem> problems = [];
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String accessToken = _prefs.getString('access') ?? '';
  http.Response response =
      await http.get(Uri.parse("$api/problems/?limit=1000"), headers: {
    'Authorization': 'Bearer $accessToken',
  });
  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);
    for (var problemJson in responseJson['results']) {
      final problem = Problem.fromJson(problemJson);
      problems.add(problem);
    }
    return problems;
  } else {
    throw Exception('Failed to load product');
  }
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

Future<List<Problem>> problemsFromDB() async {
  final Database db = await databaseFactoryIo.openDatabase(dbPath);
  final StoreRef<int, Map<String, dynamic>> store =
      StoreRef<int, Map<String, dynamic>>(DBName.problems);
  final List<RecordSnapshot<int, Map<String, dynamic>>> records =
      await store.find(db);
  return records.map((record) => Problem.fromJson(record.value)).toList();
}

Future<void> saveProblemToDB(Problem problem) async {
  final Database db = await databaseFactoryIo.openDatabase(dbPath);
  final StoreRef<int, Map<String, dynamic>> store =
      StoreRef<int, Map<String, dynamic>>(DBName.problems);
  await store.record(problem.id).put(db, problem.toJson());
}
