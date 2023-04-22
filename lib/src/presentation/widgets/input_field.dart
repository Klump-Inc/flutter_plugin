import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/src.dart';

class KCInputField extends StatefulWidget {
  const KCInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.autoFocus = false,
    this.suffix,
    this.prefix,
    this.password = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.inputFormatters = const [],
    this.validationMessage,
    this.onTap,
    this.readOnly = false,
    this.hideBorder = false,
    this.prefixText,
  });
  final TextEditingController? controller;
  final String hint;
  final void Function(String)? onChanged;
  final bool autoFocus;
  final Widget? suffix;
  final Widget? prefix;
  final bool password;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final List<TextInputFormatter> inputFormatters;
  final String? validationMessage;
  final void Function()? onTap;
  final bool readOnly;
  final bool hideBorder;
  final String? prefixText;
  @override
  State<KCInputField> createState() => _KCInputFieldState();
}

class _KCInputFieldState extends State<KCInputField> {
  late bool hidePasword;

  @override
  void initState() {
    super.initState();
    hidePasword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.4186),
            border: widget.hideBorder
                ? null
                : Border.all(
                    color: KCColors.grey1,
                    width: 0.88,
                  ),
          ),
          child: Row(
            children: [
              if (widget.prefix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: widget.prefix,
                ),
              Expanded(
                child: TextField(
                  onTap: widget.onTap,
                  controller: widget.controller,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.textInputType,
                  autofocus: widget.autoFocus,
                  focusNode: widget.focusNode,
                  style: const TextStyle(
                    color: KCColors.black3,
                    fontSize: 15,
                    fontFamily: KCFonts.avenir,
                    fontWeight: FontWeight.w500,
                  ),
                  readOnly: widget.readOnly,
                  inputFormatters: widget.inputFormatters,
                  obscureText: hidePasword,
                  textAlign: TextAlign.left,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: KCColors.grey2,
                      fontSize: 15,
                      fontFamily: KCFonts.avenir,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 16.11,
                      right: 16.11,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (widget.suffix != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: widget.suffix,
                ),
              if (widget.password)
                GestureDetector(
                  onTap: () => setState(() {
                    hidePasword = !hidePasword;
                  }),
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    child: Icon(
                      hidePasword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
