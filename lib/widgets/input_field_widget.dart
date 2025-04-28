import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const InputFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  setState(() => _obscure = !_obscure);
                },
              )
            : null,
      ),
      validator: (v) => v != null && v.isEmpty ? 'Preencha este campo' : null,
    );
  }
}
