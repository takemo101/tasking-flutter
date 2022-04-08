import 'package:flutter/material.dart';

class SortToggleButtons<T> extends StatelessWidget {
  final void Function(int)? onPressed;
  final List<bool> isSelected;
  final List<T> toggles;
  final Text Function(T) toText;

  const SortToggleButtons({
    required this.onPressed,
    required this.isSelected,
    required this.toggles,
    required this.toText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: onPressed,
      children: toggles.map((s) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: toText(s),
        );
      }).toList(),
      borderRadius: BorderRadius.circular(30.0),
      textStyle: const TextStyle(fontSize: 12),
      constraints: BoxConstraints.expand(
        width: (MediaQuery.of(context).size.width / toggles.length) - 20.0,
      ),
    );
  }
}
