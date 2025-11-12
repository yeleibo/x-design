import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:x_design/src/utils/extension/date_time_extension.dart';
import '../button/xd_clear_button.dart';

// Export OmniDateTimePickerType as DatePickerType
export 'package:omni_datetime_picker/omni_datetime_picker.dart'
    show OmniDateTimePickerType;

// Type alias for easier usage
typedef DatePickerType = OmniDateTimePickerType;

class XDDatePicker extends FormField<DateTime> {
  ///是否启用
  final bool disabled;

  ///值改变时的回调方法
  final ValueChanged<DateTime?>? onChanged;
  final DatePickerType type;
  XDDatePicker(
      {Key? key,
      this.disabled = false,
      this.onChanged,
      DateTime? initialValue,
      this.type = DatePickerType.date})
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
    DateTime? result = await showOmniDateTimePicker(
      context: context,
      type: inputDatetime.type,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      is24HourMode: true,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );

    if (result != null) {
      setValue(result);
      setState(() {});
    }
  }

  String _getFormattedTime() {
    if (value == null) return '';

    switch (inputDatetime.type) {
      case DatePickerType.date:
        return value!.toStringOfDay();
      case DatePickerType.time:
        return '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}';
      case DatePickerType.dateAndTime:
        return '${value!.toStringOfDay()} ${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}';
    }
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
        DateTime? result = await showOmniDateTimePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          is24HourMode: true,
          isShowSeconds: false,
          minutesInterval: 1,
          secondsInterval: 1,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 650,
          ),
          transitionBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              opacity: anim1.drive(
                Tween(
                  begin: 0,
                  end: 1,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: true,
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

