import 'package:flutter/material.dart';

class ParserUtil {
  static bool parseBool(dynamic value) {
    try {
      switch (value.runtimeType) {
        case int:
        case double:
        case num:
          return value == 1;
        case String:
          return value.toLowerCase() == "true";
        case bool:
          return value;
        default:
          return false;
      }
    } catch (ex) {
      return false;
    }
  }

  static String? parseString(dynamic value) {
    try {
      if (value != null) {
        return value.toString();
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  static int? parseInt(dynamic value) {
    try {
      switch (value.runtimeType) {
        case int:
          return value;
        case double:
        case num:
          return value.toInt();
        case String:
          return int.tryParse(value);
        default:
          return null;
      }
    } catch (ex) {
      return null;
    }
  }

  static double? parseDouble(dynamic value) {
    try {
      switch (value.runtimeType) {
        case int:
        case num:
          return value.toDouble();
        case double:
          return value;
        case String:
          return double.tryParse(value);
        default:
          return null;
      }
    } catch (ex) {
      return null;
    }
  }
  
  static DateTime? parseDateTime(dynamic value) {
    try {
      return DateTime.parse(value);
    } catch (ex) {
      return null;
    }
  }

  static TimeOfDay? parseTime(dynamic value) {
    try {
      switch (value.runtimeType) {
        case String:
          List<String> tmpTime = [];

          if (value.contains(" ")) {
            var tmpDateTime = value.split(" ");

            if (tmpDateTime.length >= 2) {
              tmpTime = tmpDateTime[1].split(":");
            }
          } else {
            tmpTime = value.split(":");
          }
          if (tmpTime.isEmpty) {
            return null;
          } else {
            return TimeOfDay(
              hour: int.parse(tmpTime[0]),
              minute: int.parse(tmpTime[1]),
            );
          }
        case DateTime:
          return TimeOfDay.fromDateTime(value);
        default:
          return null;
      }
    } catch (ex) {
      return null;
    }
  }
}
