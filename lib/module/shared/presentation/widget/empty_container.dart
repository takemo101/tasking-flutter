import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final String text;

  const EmptyContainer(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
      ),
      alignment: Alignment.center,
    );
  }
}
