import 'package:flutter/material.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';

class GenreDropdown extends StatefulWidget {
  final List<GenreData> list = GenreData.toGenres();
  final GenreData value;
  final Function(GenreData) onChanged;

  GenreDropdown({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _GenreDropdownState createState() => _GenreDropdownState();
}

class _GenreDropdownState extends State<GenreDropdown> {
  GenreData _value = GenreData.inital();

  @override
  initState() {
    super.initState();

    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'ジャンル',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GenreData>(
          isExpanded: true,
          isDense: true,
          value: _value,
          items: widget.list
              .map(
                (genre) => DropdownMenuItem<GenreData>(
                  value: genre,
                  child: Text(genre.name),
                ),
              )
              .toList(),
          onChanged: (genre) {
            setState(() => _value = genre ?? GenreData.inital());
            widget.onChanged(genre ?? GenreData.inital());
          },
        ),
      ),
    );
  }
}
