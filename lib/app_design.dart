import 'package:flutter/material.dart';

import 'tela.dart';

class AppColor {
  static const Color primary = Color(0xFFfc9f5b);
  static const Color secondary = Color(0xFFfbd1a2);
  static const Color backgroundAppColor = Color(0xFFFFF9F6);
  static const Color backgroundColor = Color(0xFFFFD9CB);
  static const Color foregroundColor = Color(0xFF7DFFB6);
  static const Color greenColor = Color(0xFF33CA7F);
}

ButtonStyle appButtonStyle({largura, cor}) {
  double? largura;
  Color? cor;
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColor.primary),
    foregroundColor: MaterialStateProperty.all(cor),
    minimumSize: MaterialStateProperty.all(Size(30, largura ?? 60)),
  );
}

InputDecoration inputDecorat() {
  return InputDecoration(
    errorText: errorText,
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.primary, width: 1.3),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    label: const Text('Digite uma tarefa'),
    labelStyle: const TextStyle(color: AppColor.primary),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary, width: 1.3)),
  );
}
