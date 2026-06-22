import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/themes.dart';

Future<void> showDatePickerDialog(
    BuildContext context,
    String dateString,
    Function(String) onDateSelected,
    ) async {

  DateTime? pickedDate = await showDatePicker(

    context: context,

    initialDate: DateFormat('dd.MM.yyyy').parse(dateString),

    firstDate: DateTime(2000),

    lastDate: DateTime(2100),

    builder: (context, child) {
      final baseTheme = currentTheme.isDark
          ? ThemeData.dark()
          : ThemeData.light();

      return Theme(
        data: baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: accentColor,
            surface: background1Color,
            onSurface: foregroundColor, // important
            onPrimary: Colors.white,
          ),

          dialogTheme: DialogThemeData(
            backgroundColor: background1Color,
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: accentColor,
            ),
          ),

          textTheme: baseTheme.textTheme.apply(
            bodyColor: foregroundColor,
            displayColor: foregroundColor,
          ),
        ),

        child: child!,
      );
    },
  );

  if (pickedDate != null) {

    String formattedDate =
    DateFormat('dd.MM.yyyy').format(pickedDate);

    onDateSelected(formattedDate);
  }
}