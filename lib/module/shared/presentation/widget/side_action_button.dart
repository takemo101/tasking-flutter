import 'package:flutter/material.dart';

class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function() onPressed;

  const AppBarActionButton({
    required this.icon,
    required this.text,
    Color textColor = Colors.white,
    required this.onPressed,
    Key? key,
  })  : color = textColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
