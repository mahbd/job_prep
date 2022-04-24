import 'package:flutter/material.dart';

class HOSlidableList extends StatelessWidget {
  const HOSlidableList(
      {Key? key,
      required this.items,
      required this.changeItem,
      this.currentItem})
      : super(key: key);

  final List<Map<String, dynamic>> items;
  final Map<String, dynamic>? currentItem;
  final Function changeItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: MaterialButton(
              minWidth: 100,
              shape: const StadiumBorder(),
              color: Colors.black,
              onPressed: () {
                  changeItem(items[index]);
              },
              child: Text(
                items[index]['name'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
