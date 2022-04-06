import 'package:flutter/material.dart';
import 'package:tasking/module/scene/application/dto/scene_data.dart';

class SceneTypeDropdown extends StatefulWidget {
  final List<SceneTypeData> list = SceneTypeData.toTypes();
  final SceneTypeData value;
  final Function(SceneTypeData) onChanged;

  SceneTypeDropdown({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _SceneTypeDropdownState createState() => _SceneTypeDropdownState();
}

class _SceneTypeDropdownState extends State<SceneTypeDropdown> {
  SceneTypeData _value = SceneTypeData.inital();

  @override
  initState() {
    super.initState();

    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: '管理モード',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SceneTypeData>(
          isExpanded: true,
          isDense: true,
          value: _value,
          items: widget.list
              .map(
                (type) => DropdownMenuItem<SceneTypeData>(
                  value: type,
                  child: Text(type.name),
                ),
              )
              .toList(),
          onChanged: (type) {
            setState(() => _value = type ?? SceneTypeData.inital());
            widget.onChanged(type ?? SceneTypeData.inital());
          },
        ),
      ),
    );
  }
}
