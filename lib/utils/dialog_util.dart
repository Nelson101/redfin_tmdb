import 'dart:async';

import 'package:flutter/material.dart';

class DialogUtil {
  static const double _defaultPadding = 16;
  static const double _borderRadius = 8;

  static Future<bool?>? showConfirmationDialogBox(
    BuildContext? context,
    String message, {
    titleTxt = "Confirmation",
    yesBtnTxt = "Yes",
    noBtnTxt = "No",
  }) {
    if (context == null) return null;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        noBtnTxt,
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        yesBtnTxt,
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        titleTxt,
      ),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showStatusDialog(
    BuildContext? context,
    String message, {
    bool isSuccess = true,
  }) {
    if (context == null) return;

    Timer? timer;

    showDialog(
        context: context,
        builder: (context) {
          timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _defaultPadding),
              child: Material(
                borderRadius: BorderRadius.circular(_borderRadius),
                color: Colors.black,
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      isSuccess
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 40,
                            )
                          : const Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                              size: 40,
                            ),
                      if (message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "roboto",
                              color: Colors.white,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).then((_) {
      if (timer != null && timer?.isActive == true) {
        timer?.cancel();
      }
    });
  }
}
