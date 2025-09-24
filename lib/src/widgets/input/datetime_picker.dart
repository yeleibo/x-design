import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:x_design/src/utils/extension/date_time_extension.dart';

import '../button/xd_clear_button.dart';

class XDDateTimePicker extends FormField<DateTime> {
  ///是否启用
  final bool disabled;

  ///值改变时的回调方法
  final ValueChanged<DateTime?>? onChanged;

  final OmniDateTimePickerType type;

  XDDateTimePicker({
    Key? key,
    this.disabled = false,
    this.onChanged,
    this.type = OmniDateTimePickerType.dateAndTime,
    DateTime? initialValue,
  }) : super(
            key: key,
            initialValue: initialValue,
            builder: (FormFieldState<DateTime> field) {
              final XDDatetimeState state = field as XDDatetimeState;
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
                child: IconClose2(
                  state: state,
                  disabled: disabled,
                ),
              );
            });

  @override
  XDDatetimeState createState() => XDDatetimeState();
}

class XDDatetimeState extends FormFieldState<DateTime> {
  XDDateTimePicker get inputDatetime => super.widget as XDDateTimePicker;

  Future<void> _showTimePicker(BuildContext context) async {
    var now = DateTime.now();
    var result = await showOmniDateTimePicker(
      context: context,
      initialDate: value ?? DateTime(now.year,now.month,now.day,12,0),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      type: inputDatetime.type,
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
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    if (result != null) {
      setValue(result);
      setState(() {});
    }
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

class IconClose2 extends StatefulWidget {
  final XDDatetimeState state;
  final bool disabled;
  const IconClose2({Key? key, required this.state, required this.disabled})
      : super(key: key);

  @override
  State<IconClose2> createState() => _IconClose2State();
}

class _IconClose2State extends State<IconClose2> {
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
                widget.state.value?.toStringOfMinute() ?? '',
                style: Theme.of(widget.state.context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: widget.disabled ? Colors.grey : null),
              ),
              if (widget.state.value != null && isHover == true && !widget.disabled)
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
