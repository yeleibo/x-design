import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:x_design/src/utils/extension/date_time_extension.dart';
import '../button/xd_clear_button.dart';

class XDDatePicker extends FormField<DateTime> {
  ///是否启用
  final bool disabled;

  ///值改变时的回调方法
  final ValueChanged<DateTime?>? onChanged;
  final XDDatePickerType xdDatePickerType;
  XDDatePicker(
      {Key? key,
      this.disabled = false,
      this.onChanged,
      DateTime? initialValue,
      this.xdDatePickerType = XDDatePickerType.day})
      : super(
            key: key,
            initialValue: initialValue,
            builder: (FormFieldState<DateTime> field) {
              final XDInputDatetimeState state = field as XDInputDatetimeState;
              return InkWell(
                mouseCursor: disabled ? SystemMouseCursors.forbidden : null,
                onTap: disabled
                    ? null
                    : () async {
                        await state._showTimePicker(state.context);

                        if (state.value != null) {
                          onChanged?.call(state.value);
                        }
                      },
                child: IconClose(
                  state: state,
                  disabled: disabled,
                ),
              );
            });

  @override
  XDInputDatetimeState createState() => XDInputDatetimeState();
}

class XDInputDatetimeState extends FormFieldState<DateTime> {
  XDDatePicker get inputDatetime => super.widget as XDDatePicker;

  Future<void> _showTimePicker(BuildContext context) async {
    var result = await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Select Date'),
          content: Container(
            width: 300,
            height: 300,
            child: SfDateRangePicker(
              view: inputDatetime.xdDatePickerType == XDDatePickerType.year
                  ? DateRangePickerView.decade
                  : inputDatetime.xdDatePickerType == XDDatePickerType.month
                      ? DateRangePickerView.year
                      : DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              showActionButtons: true,
              initialSelectedDate: value,
              showNavigationArrow: true,
              allowViewNavigation:
                  inputDatetime.xdDatePickerType == XDDatePickerType.day
                      ? true
                      : false,
              headerStyle: const DateRangePickerHeaderStyle(),
              confirmText: '确认',
              cancelText: '取消',
              onSubmit: (value) {
                Navigator.of(context).pop(value);
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setValue(result);
      setState(() {});
    }
  }

  String _getFormattedTime() {
    return inputDatetime.xdDatePickerType == XDDatePickerType.year
        ? value?.year.toString() ?? ''
        : inputDatetime.xdDatePickerType == XDDatePickerType.month
            ? value?.toStringOfMonth() ?? ''
            : value?.toStringOfDay() ?? '';
  }

  @override
  void initState() {
    if (widget.initialValue != null && inputDatetime.onChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        inputDatetime.onChanged!(widget.initialValue);
      });
    }
    super.initState();
  }

  @override
  void reset() {
    inputDatetime.onChanged?.call(inputDatetime.initialValue);
    super.reset();
  }

  void clear() {
    inputDatetime.onChanged?.call(null);
    setState(() {
      setValue(null);
    });
  }

  @override
  void didUpdateWidget(covariant FormField<DateTime> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        setValue(widget.initialValue);
      });
    }
  }
}

class IconClose extends StatefulWidget {
  final XDInputDatetimeState state;
  final bool disabled;
  const IconClose({Key? key, required this.state, required this.disabled})
      : super(key: key);

  @override
  State<IconClose> createState() => _IconCloseState();
}

class _IconCloseState extends State<IconClose> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.shade300)),
          alignment: Alignment.centerLeft,
          // color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.state._getFormattedTime(),
                style: Theme.of(widget.state.context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: widget.disabled ? Colors.grey : null),
              ),
              if (widget.state._getFormattedTime().isNotEmpty &&
                  isHover == true)
                XDClearButton(
                  onTap: () {
                    widget.state.clear();
                  },
                  size: 15,
                ),
            ],
          )),
    );
  }
}

class DatesPicker extends StatefulWidget {
  final ValueChanged<DateTime>? onAdded;
  final List<DateTime>? initialValues;
  final ValueChanged<DateTime>? onDeleted;
  const DatesPicker(
      {super.key, this.onAdded, this.initialValues = const [], this.onDeleted});

  @override
  State<DatesPicker> createState() => _DatesPickerState();
}

class _DatesPickerState extends State<DatesPicker> {
  List<DateTime> selectedTimes = [];
  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      selectedTimes.addAll(widget.initialValues!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var result = await showDialog<DateTime>(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text('Select Date'),
              content: Container(
                width: 300,
                height: 300,
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  showActionButtons: true,
                  initialSelectedDate: DateTime.now(),
                  showNavigationArrow: true,
                  headerStyle: const DateRangePickerHeaderStyle(),
                  confirmText: '确认',
                  cancelText: '取消',
                  onSubmit: (value) {
                    Navigator.of(context).pop(value);
                  },
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
        if (result != null) {
          selectedTimes.add(result);
          widget.onAdded?.call(result);
        }
      },
      child: Container(
          height: selectedTimes.isEmpty ? 30 : null,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.shade300)),
          alignment: Alignment.centerLeft,
          // color: Colors.red,
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...selectedTimes.map((e) => Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.toStringOfDay(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTimes.remove(e);
                                  widget.onDeleted?.call(e);
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  @override
  void didUpdateWidget(covariant DatesPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValues != widget.initialValues) {
      selectedTimes.clear();
      selectedTimes.addAll(widget.initialValues!);
    }
  }
}

enum XDDatePickerType {
  year,
  month,
  day,
}
