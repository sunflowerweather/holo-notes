import 'package:flutter/cupertino.dart';
import 'package:holo_notes/service/local_data_manager.dart';

import '../classes/day.dart';
import '../classes/note.dart';
import 'package:share_plus/share_plus.dart';

void addNote({
  required Map<String, Day> days,
  required String dateString,
  required VoidCallback onUpdate,
}) {
  days.putIfAbsent(dateString, () => Day(notes: []));

  final notes = days[dateString]!.notes;



  notes.add(
    Note(
      title: 'Title ${notes.length + 1}',
      text: '',
    ),
  );

  saveMap(days);

  onUpdate();
}
void deleteNote({
  required Map<String, Day> days,
  required String dateString,
  required int index,
  required VoidCallback onUpdate,
}) {
  if (!days.containsKey(dateString)) return;

  days[dateString]!.notes.removeAt(index);

  if (days[dateString]!.notes.isEmpty) {
    days.remove(dateString);
  }
  saveMap(days);
  onUpdate();
}
void editNote({
  required Map<String, Day> days,
  required String dateString,
  required int index,
  required BuildContext context,
  required VoidCallback onUpdate,
  required void Function(
      int index,
      Map<String, Day> days,
      String dateString,
      BuildContext context,
      VoidCallback refresh,
      )
  openEditDialog,
}) {
  if (!days.containsKey(dateString)) return;

  openEditDialog(
    index,
    days,
    dateString,
    context,
    onUpdate,
  );
}

void shareNote({
  required Map<String, Day> days,
  required String dateString,
  required int index,
}) {
  if (!days.containsKey(dateString)) return;

  final note = days[dateString]!.notes[index];

  String shareText = '''
${note.title}
${note.text}

sent from Holo Notes
''';
  shareText = shareText.replaceAll('|', '');

  Share.share(shareText);
}

Future<void> favouriteNote({
  required Map<String, Day> days,
  required String dateString,
  required int index,
  required BuildContext context,
}) async {
  final day = days[dateString];
  if (day == null) return;

  if (index < 0 || index >= day.notes.length) return;

  day.notes[index].isFavourited = !day.notes[index].isFavourited;
  await saveMap(days);
}