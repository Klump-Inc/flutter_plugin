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
                color: KCColors.white,
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
                      selectionColor: KCColors.primary,
                      todayHighlightColor: KCColors.lightBlue,
                      viewSpacing: 10,
                      selectionTextStyle: const TextStyle(
                        fontFamily: KCFonts.avenir,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      headerStyle: const DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                          fontFamily: KCFonts.avenir,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: KCColors.black1,
                        ),
                      ),
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                          fontFamily: KCFonts.avenir,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: KCColors.black1,
                        ),
                        todayTextStyle: TextStyle(
                          fontFamily: KCFonts.avenir,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: KCColors.lightBlue,
                        ),
                      ),
                      yearCellStyle: const DateRangePickerYearCellStyle(
                        textStyle: TextStyle(
                          fontFamily: KCFonts.avenir,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: KCColors.black1,
                        ),
                        todayTextStyle: TextStyle(
                          fontFamily: KCFonts.avenir,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: KCColors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: KCColors.grey7,
                    height: 0.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onDateSelected(
                          _controller.selectedDate ?? DateTime.now());
                    },
                    child: const SizedBox(
                      height: 55,
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: KCFonts.avenir,
                            fontWeight: FontWeight.w500,
                            color: KCColors.lightBlue,
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
                  color: KCColors.white,
                  borderRadius: BorderRadius.circular(13.2),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: KCFonts.avenir,
                      fontWeight: FontWeight.w500,
                      color: KCColors.lightBlue,
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
