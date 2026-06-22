import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required import
import 'package:holo_notes/dialogs/highlighted_words_dialog.dart';
import 'package:holo_notes/dialogs/longpressdialog.dart';
import 'package:holo_notes/dialogs/settingsdialog.dart';
import 'package:holo_notes/service/convert_date.dart';
import 'package:holo_notes/service/date_service.dart';
import 'package:holo_notes/service/local_data_manager.dart';
import 'package:holo_notes/service/theme_prefs.dart';
import 'package:holo_notes/service/themes.dart';
import 'package:holo_notes/widgets/date_header.dart';
import 'package:holo_notes/widgets/notes_list.dart';

import 'package:intl/intl.dart';

import 'classes/day.dart';
import 'classes/globals.dart';
import 'dialogs/date_picker_dialog.dart';
import 'dialogs/deletedialog.dart';
import 'dialogs/editordialog.dart';
import 'dialogs/favourites_dialog.dart';
import 'note_voids.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedId = await ThemePrefs.loadThemeId();

  if (savedId != null && savedId < themesList.length) {
    curThemeID.value = savedId;
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  days.value = await loadMap(); // must become async

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holo Notes',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: accentColor),
        useMaterial3: false,

      ),
      home: const MyHomePage(title: 'Holo Notes'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

DateTime now = DateTime.now();
String dateString = DateFormat("dd.MM.yyyy").format(DateTime.now()).toString();






class _MyHomePageState extends State<MyHomePage> {



  void changeDate(String newDate) {
    setState(() {
      dateString = newDate;
    });
  }



  void datePicker()
  {

    showDatePickerDialog(
      context,
      dateString,
          (selectedDate) {

        setState(() {
          dateString = selectedDate;
        });

      },
    );
  }

  void addNoteFAB(){
    setState(() {
      addNote(
        days: days.value,
        dateString: dateString,
        onUpdate: () => setState(() {}),
      );
    });
  }

  void showSettings()
  {
    setState(() {
      showSettingsDialog(context);

    });
  }

  void showFavDialog()
  {
    showFavouritesDialog(
      context: context,
      days: days,
      dateString: dateString,
      onChangeDate: changeDate,
    );

  }

  void showHighlDialog()
  {
    showHighlightedDialog(
      context: context,
      days: days,
      dateString: dateString,
      onChangeDate: changeDate,
    );

  }



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: curThemeID,
      builder: (context, value, _) {
        final theme = themesList[value];

        final backgroundGradient = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.background2Color,
              theme.background1Color,
            ],
          ),
        );

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onHorizontalDragEnd: (details) {

              // Swipe Right
              if (details.primaryVelocity! > 0) {
                changeDayMinus(
                  dateString: dateString,
                  onChanged: (newDate) {
                    setState(() => dateString = newDate);
                  },
                );
              }

              // Swipe Left
              else if (details.primaryVelocity! < 0) {
                changeDayPlus(
                  dateString: dateString,
                  onChanged: (newDate) {
                    setState(() => dateString = newDate);
                  },
                );
              }
            },
            child: Container(
              decoration: backgroundGradient,
              child: SafeArea(
                child: Column(
                  children: [
                    DateHeader(
                      accentColor: theme.accentColor,
                      dateText: convertDate(dateString),

                      onPrevDay: () {
                        changeDayMinus(
                          dateString: dateString,
                          onChanged: (newDate) {
                            setState(() => dateString = newDate);
                          },
                        );
                      },

                      onNextDay: () {
                        changeDayPlus(
                          dateString: dateString,
                          onChanged: (newDate) {
                            setState(() => dateString = newDate);
                          },
                        );
                      },

                      onOpenPicker: datePicker,
                    ),

                    Container(height: 2, color: theme.accentColor),

                    Expanded(
                      child: NotesList(
                        days: days,
                        dateString: dateString,

                        onEdit: (index) {
                          editNote(
                            days: days.value,
                            dateString: dateString,
                            index: index,
                            context: context,
                            onUpdate: () => setState(() {}),
                            openEditDialog: openEditDialog,
                          );
                        },

                        onOptions: (index) {
                          showLongPressOptions(

                            context,

                                  () => deleteNote(
                                days: days.value,
                                dateString: dateString,
                                index: index,
                                onUpdate: () => setState(() {}),

                              ),
                                  () => favouriteNote(
                                days: days.value,
                                dateString: dateString,
                                index: index,
                                context: context,

                              ),

                                  () => shareNote(
                                days: days.value,
                                dateString: dateString,
                                index: index,


                              ),
                              days.value[dateString]!.notes[index].title,
                              days.value[dateString]!.notes[index].isFavourited
                          );

                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [

                          SizedBox(
                            width: 40,
                            height: 40,
                            child: TextButton(
                              onPressed: showFavDialog,
                              style: ButtonStyle(
                                backgroundColor:
                                WidgetStatePropertyAll(theme.background1Color),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                    side: BorderSide(
                                      color: theme.accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.star_border,
                                color: theme.accentColor,
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          SizedBox(
                            width: 40,
                            height: 40,
                            child: TextButton(
                              onPressed: showHighlDialog,
                              style: ButtonStyle(
                                backgroundColor:
                                WidgetStatePropertyAll(theme.background1Color),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                    side: BorderSide(
                                      color: theme.accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.bookmark_border,
                                color: theme.accentColor,
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextButton(
                                onPressed: addNoteFAB,
                                style: ButtonStyle(
                                  backgroundColor:
                                  WidgetStatePropertyAll(theme.background1Color),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                      side: BorderSide(
                                        color: theme.accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: theme.accentColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          SizedBox(
                            width: 40,
                            height: 40,
                            child: TextButton(
                              onPressed: showSettings,
                              style: ButtonStyle(
                                backgroundColor:
                                WidgetStatePropertyAll(theme.background1Color),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                    side: BorderSide(
                                      color: theme.accentColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.settings,
                                color: theme.accentColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(bottom: 20))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

///TODO:
///
/// 3) favourite notes


