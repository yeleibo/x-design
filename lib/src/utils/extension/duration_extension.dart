
extension DurationExtension on Duration? {
  String toFormatString(){
    final ms = this?.inMilliseconds??0;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours.toString().padLeft(2, '0');

    final minutesString = minutes.toString().padLeft(2, '0');;

    final secondsString = seconds.toString().padLeft(2, '0');;

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

}
