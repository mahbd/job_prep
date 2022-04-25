import 'package:flutter/material.dart';

import '../models/problem.dart';
import '../widget/horizontal_oneline_slidable_list.dart';
import '../widget/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [
    {'name': 'Google'},
    {'name': 'Facebook'},
    {'name': 'Apple'},
    {'name': 'Microsoft'},
    {'name': 'Amazon'},
    {'name': 'Netflix'},
    {'name': 'Uber'},
    {'name': 'Tesla'},
    {'name': 'SpaceX'},
  ];
  Map<String, dynamic>? currentItem = {'name': 'Google'};
  List<Problem> problems = [];

  void changeItem(Map<String, dynamic> item) {
    setState(() {
      currentItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Problem> showProblems;
    if (currentItem != null) {
      showProblems = problems
          .where((problem) =>
              problem.companies?.contains(currentItem!['name']) ?? false)
          .toList();
    } else {
      showProblems = problems;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              problems = await problemsFromHttp();
              for (var problem in problems) {
                saveProblemToDB(problem);
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const SearchWidget(),
          const SizedBox(height: 10),
          HOSlidableList(
            items: items,
            changeItem: changeItem,
            currentItem: currentItem,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {},
                color: Colors.black,
                shape: const StadiumBorder(),
                child: Text(
                  'Showing problems for ${currentItem != null ? currentItem!['name'] : 'All'}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(onPressed: () {
                setState(() {
                  currentItem = null;
                });
              }, icon: const Icon(Icons.clear)),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: showProblems.length,
                itemBuilder: (context, index) {
                  Color color = Colors.white;
                  if (showProblems[index].status == 'Solved') {
                    color = Colors.blue;
                  } else if (showProblems[index].status == 'Confident') {
                    color = Colors.green;
                  } else if (showProblems[index].status == 'Tried') {
                    color = Colors.red;
                  }
                  return Card(
                    child: ListTile(
                      tileColor: color,
                      title: Text(showProblems[index].name),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(showProblems[index].acceptance.toString()),
                          Text(showProblems[index].difficulty),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
