import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class KCAndroidDatePickerContainer extends StatefulWidget {
  const KCAndroidDatePickerContainer({
    super.key,
    required this.onDateSelected,
    this.onCancel,
    this.initialDate,
  });
  final void Function(DateTime?) onDateSelected;
  final void Function()? onCancel;
  final DateTime? initialDate;

  @override
  State<KCAndroidDatePickerContainer> createState() =>
      _KCAndroidDatePickerContainerState();
}

class _KCAndroidDatePickerContainerState
    extends State<KCAndroidDatePickerContainer> {
  late DateRangePickerController _controller;
  @override
  void initState() {
    _controller = DateRangePickerController();
    _controller.selectedDate = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 30,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13.2),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(13.2),
              ),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(10),
                    child: SfDateRangePicker(
                      controller: _controller,
                      initialDisplayDate: widget.initialDate,
                      headerHeight: 50,
                      showNavigationArrow: true,
                      toggleDaySelection: true,
                      selectionColor: Theme.of(context).primaryColor,
                      todayHighlightColor: Theme.of(context).highlightColor,
                      viewSpacing: 10,
                      selectionTextStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                height: 1,
                                color: Colors.white,
                              ),
                      headerStyle: DateRangePickerHeaderStyle(
                        textStyle:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  height: 1.2,
                                  fontSize: 12,
                                ),
                        todayTextStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  height: 1.2,
                                  fontSize: 12,
                                  color: Theme.of(context).highlightColor,
                                ),
                      ),
                      yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  height: 1.2,
                                  fontSize: 12,
                                ),
                        todayTextStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  height: 1.2,
                                  fontSize: 12,
                                  color: Theme.of(context).highlightColor,
                                ),
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 0.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onDateSelected(
                          _controller.selectedDate ?? DateTime.now());
                    },
                    child: SizedBox(
                      height: 55,
                      child: Center(
                        child: Text(
                          'Confirm',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).highlightColor,
                                    fontSize: 16,
                                    height: 1.2,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(13.2),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).highlightColor,
                          fontSize: 16,
                          height: 1.2,
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
