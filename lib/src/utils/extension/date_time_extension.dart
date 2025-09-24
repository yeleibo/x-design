// 使用 import 'package:x_gis_window/extension/date_time_extension.dart';
extension DateTimeExtension on DateTime? {
  String toStringOfMonth({String splitString = '-'}) {
    return this == null
        ? ""
        : "${this!.year}$splitString${this!.month.toString().padLeft(2, '0')}";
  }

  String toStringOfDay({String splitString = '-'}) {
    return this == null
        ? ""
        : "${this!.year}$splitString${this!.month.toString().padLeft(2, '0')}$splitString${this!.day.toString().padLeft(2, '0')}";
  }

  String toStringOfMinute({String splitString = '-'}) {
    return this == null
        ? ""
        : '${this!.year}$splitString${this!.month.toString().padLeft(2, '0')}$splitString${this!.day.toString().padLeft(2, '0')} ${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}';
  }

  String toStringOfSecond({String splitString = '-'}) {
    return this == null
        ? ""
        : "${this!.year}$splitString${this!.month.toString().padLeft(2, '0')}$splitString${this!.day.toString().padLeft(2, '0')} ${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}:${this!.second.toString().padLeft(2, '0')}";
  }
  String toStringOfChinaDay() {
    return this == null
        ? ""
        : "${this!.year}年${this!.month.toString().padLeft(2, '0')}月${this!.day.toString().padLeft(2, '0')}日";
  }
  ///带秒的时间戳
  int? get secondsSinceEpoch{
    return this == null
        ? null
        :  this!.millisecondsSinceEpoch~/1000;
  }
}

extension DateTimeExtension2 on DateTime {
  ///带秒的时间戳
  int?  get secondsSinceEpoch{
    return millisecondsSinceEpoch~/1000;
  }
}