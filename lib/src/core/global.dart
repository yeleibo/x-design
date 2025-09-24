import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

///是否是桌面端
 bool  isDesktop = kIsWeb ||
    Platform.isFuchsia ||
    Platform.isLinux ||
    Platform.isMacOS ||
    Platform.isWindows;

///是否是移动端
bool isMobile = !isDesktop;

String? getExceptionMessage(dynamic e) {
  if (e is DioException) {
    return e.message??'network error';
  }
  return null;
}


List<List<double>> nms(List<List<double>> boxes, double iouThreshold) {
  List<List<double>> filteredBoxes = List<List<double>>.from(boxes);

  for (int i = 0; i < filteredBoxes.length; i++) {
    final box = filteredBoxes[i];
    for (int j = i + 1; j < filteredBoxes.length; j++) {
      final nextBox = filteredBoxes[j];
      final double x1 = max(nextBox[0], box[0]);
      final double y1 = max(nextBox[1], box[1]);
      final double x2 = min(nextBox[2], box[2]);
      final double y2 = min(nextBox[3], box[3]);

      final double width = max(0, x2 - x1);
      final double height = max(0, y2 - y1);

      final double intersection = width * height;
      final double union = (nextBox[2] - nextBox[0]) * (nextBox[3] - nextBox[1]) + (box[2] - box[0]) * (box[3] - box[1]) - intersection;
      final double iou = intersection / union;
      if (iou > iouThreshold) {
        filteredBoxes.removeAt(j);
        j--;
      }
    }
  }

  return filteredBoxes;
}


