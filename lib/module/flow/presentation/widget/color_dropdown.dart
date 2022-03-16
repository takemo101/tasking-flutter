import 'package:flutter/material.dart';
import 'package:tasking/module/shared/presentation/widget/color_point.dart';

@immutable
class SelectColor {
  final String label;
  final Color color;

  const SelectColor({
    required this.label,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      other is SelectColor && other.color == color;

  @override
  int get hashCode => color.hashCode;
}

class SelectColors {
  final List<SelectColor> _colors = [
    const SelectColor(
      label: 'レッド',
      color: Colors.red,
    ),
    const SelectColor(
      label: 'ピンク',
      color: Colors.pink,
    ),
    const SelectColor(
      label: 'オレンジ',
      color: Colors.orange,
    ),
    const SelectColor(
      label: 'アンバー',
      color: Colors.amber,
    ),
    const SelectColor(
      label: 'イエロー',
      color: Colors.yellow,
    ),
    const SelectColor(
      label: 'グリーン',
      color: Colors.green,
    ),
    const SelectColor(
      label: 'シアン',
      color: Colors.cyan,
    ),
    const SelectColor(
      label: 'ブルー',
      color: Colors.blue,
    ),
    const SelectColor(
      label: 'パープル',
      color: Colors.purple,
    ),
    const SelectColor(
      label: 'グレイ',
      color: Colors.grey,
    ),
    const SelectColor(
      label: 'ブラック',
      color: Colors.black,
    ),
  ];

  bool has(SelectColor color) {
    return _colors.indexWhere((c) => c == color) != -1;
  }

  SelectColor findByColor(Color color) {
    return _colors.firstWhere((c) => c.color.value == color.value);
  }

  List<SelectColor> get colors => [..._colors];

  SelectColor initial() {
    return _colors.first;
  }

  static SelectColor firstColor() {
    return SelectColors().initial();
  }
}

class ColorDropdown extends StatefulWidget {
  final Color color;
  final Function(Color) onChanged;

  const ColorDropdown({
    required this.color,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _ColorDropdownState createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  final SelectColors _colors = SelectColors();
  SelectColor _value = SelectColors.firstColor();

  @override
  initState() {
    super.initState();

    _value = _colors.findByColor(widget.color);
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'カラー',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SelectColor>(
          isExpanded: true,
          isDense: true,
          value: _value,
          items: _colors.colors
              .map(
                (c) => DropdownMenuItem<SelectColor>(
                  value: c,
                  child: Row(
                    children: [
                      ColorPoint(
                        c.color,
                        margin: const EdgeInsets.only(right: 10),
                      ),
                      Text(c.label),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (c) {
            setState(() => _value = c ?? _colors.initial());
            widget.onChanged(c != null ? c.color : _colors.initial().color);
          },
        ),
      ),
    );
  }
}
