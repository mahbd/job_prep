import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../models/problem.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({required this.problem, Key? key}) : super(key: key);

  final Problem problem;

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.problem.name),
      ),
      body: ListView(
        children: <Widget>[
          HtmlWidget(
            widget.problem.questionHtml,
            enableCaching: true,
            textStyle: const TextStyle(fontSize: 16, fontFamily: 'Times New Roman'),
          ),
        ],
      ),
    );
  }
}
