import 'package:flutter/material.dart';

import '../service/themes.dart';

void showLongPressOptions(
    BuildContext context,
    VoidCallback onDelete,
    VoidCallback onFavourite,
    VoidCallback onShare,
    String noteTitle,
    bool isFavourited
    ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: background1Color,

        title: Text(
          'Manage $noteTitle',
          style: TextStyle(color: foregroundColor),
          textAlign: TextAlign.center,
        ),


        actions: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                // CANCEL
                SizedBox(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(background1Color),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                          side: BorderSide(
                            color: accentColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Favourite
                SizedBox(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    onPressed: () {

                      onFavourite();

                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(background1Color),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                          side: BorderSide(
                            color: accentColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Icon(
                      isFavourited ? Icons.star : Icons.star_border,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Delete
                SizedBox(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    onPressed: () {

                      onDelete();

                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(background1Color),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                          side: BorderSide(
                            color: accentColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.delete_forever,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Delete
                SizedBox(
                  width: 40,
                  height: 40,
                  child: TextButton(
                    onPressed: () {

                      onShare();

                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(background1Color),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                          side: BorderSide(
                            color: accentColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.share,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          )



        ],
      );
    },
  );
}