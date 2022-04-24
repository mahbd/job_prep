import 'package:flutter/material.dart';
import 'package:job_prep/widget/horizontal_oneline_slidable_list.dart';
import 'package:job_prep/widget/search.dart';

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

  void changeItem(Map<String, dynamic> item) {
    setState(() {
      currentItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
          MaterialButton(
            onPressed: () {},
            color: Colors.black,
            shape: const StadiumBorder(),
            child: Text(
              'Showing problems for ${currentItem != null ? currentItem!['name'] : 'All companies'}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(items[index]['name']),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
