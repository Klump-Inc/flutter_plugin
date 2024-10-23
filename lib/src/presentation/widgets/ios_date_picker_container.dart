import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCIOSDatePickerContainer extends StatefulWidget {
  const KCIOSDatePickerContainer({
    super.key,
    required this.onDateSelected,
    this.onCancel,
    this.initialDate,
  });
  final void Function(DateTime?) onDateSelected;
  final void Function()? onCancel;
  final DateTime? initialDate;

  @override
  State<KCIOSDatePickerContainer> createState() =>
      _KCIOSDatePickerContainerState();
}

class _KCIOSDatePickerContainerState extends State<KCIOSDatePickerContainer> {
  @override
  void initState() {
    _date = widget.initialDate;
    super.initState();
  }

  DateTime? _date;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 61.7,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: KCColors.white,
              borderRadius: BorderRadius.circular(13.2),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    initialDateTime: widget.initialDate ?? DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _date = newDate;
                      });
                    },
                  ),
                ),
                Container(
                  color: KCColors.grey7,
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onDateSelected(_date ?? DateTime.now());
                  },
                  child: SizedBox(
                    height: 55,
                    child: Center(
                      child: Material(
                        color: Colors.white,
                        child: KCHeadline5(
                          'Confirm',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const YSpace(8),
          GestureDetector(
            onTap: widget.onCancel,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: KCColors.white,
                borderRadius: BorderRadius.circular(13.2),
              ),
              child: Center(
                child: Material(
                  color: Colors.white,
                  child: KCHeadline5(
                    'Cancel',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
