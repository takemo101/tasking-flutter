import 'package:flutter/material.dart';

class ListIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ListIconButton({
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.grey,
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
