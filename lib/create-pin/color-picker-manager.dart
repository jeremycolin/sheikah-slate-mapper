import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerManager extends FormField<Color> {
  final void Function(Color color) onChange;

  ColorPickerManager(
    this.onChange, {
    Color initialValue,
  }) : super(
            initialValue: initialValue,
            builder: (FormFieldState<Color> field) {
              return AlertDialog(
                  title: Center(child: Text('Select Pin color')),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: initialValue,
                      onColorChanged: (color) {
                        field.didChange(color);
                        onChange(color);
                      },
                    ),
                  ));
            });
}
