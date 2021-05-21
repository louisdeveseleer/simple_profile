import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    Key key,
    this.initialValue,
    @required this.onChanged,
    @required this.enabled,
    this.hintText,
  }) : super(key: key);
  final String initialValue;
  final Function(String) onChanged;
  final bool enabled;
  final String hintText;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      widget.onChanged(_controller.value.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      return TextField(
        controller: _controller,
        maxLength: 30,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
      );
    } else {
      return Text(_controller.text.isEmpty ? '-' : _controller.text);
    }
  }
}
