import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
    this.value, {
    super.key,
    this.style,
    this.maxLines,
    this.textAlign,
    this.overflow,
  });

  final int? maxLines;
  final String? value;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ?? '-',
      overflow: overflow,
      maxLines: maxLines,
      style: style,
      textAlign: textAlign,
    );
  }
}
