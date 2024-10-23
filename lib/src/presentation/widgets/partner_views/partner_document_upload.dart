import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerDocumentUpload extends StatefulWidget {
  const PartnerDocumentUpload({super.key});

  @override
  State<PartnerDocumentUpload> createState() => _PartnerDocumentUploadState();
}

class _PartnerDocumentUploadState extends State<PartnerDocumentUpload> {
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  late TextEditingController _idNumberCtrl;
  final _idNumberFocus = FocusNode();
  late StreamController<String> idNumberStreamCtrl;
  File? _documentFile;

  void validateInputs() {
    final documentType =
        Provider.of<KCChangeNotifier>(context, listen: false).documentType;
    final addressError = KCFormValidator.errorMessageIdNumber(
      _idNumberCtrl.text.trim(),
      'Required',
      documentType!,
    );
    if (addressError?.isEmpty == true && _documentFile != null) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  Future<void> selectDocumentImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    File? image;
    if (source == ImageSource.camera) {
      image = await PhotoPicker.fromCamera();
    } else {
      image = await PhotoPicker.fromLibrary();
    }
    if (image != null) {
      setState(() {
        _documentFile = image;
      });
      validateInputs();
    }
  }

  @override
  void initState() {
    super.initState();
    _idNumberCtrl = TextEditingController();
    idNumberStreamCtrl = StreamController<String>.broadcast();
    _idNumberCtrl.addListener(() {
      idNumberStreamCtrl.sink.add(_idNumberCtrl.text.trim());
      validateInputs();
    });
    _idNumberFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    idNumberStreamCtrl.close();
    _idNumberFocus
      ..removeListener(_onFocusChange)
      ..dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.documentVerificationStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
    Logger().d(formFields);
    var cardSample = '';
    switch (checkoutNotfier.documentType) {
      case INTERNATIONAL_PASSPORT:
        cardSample = KCAssets.intlPassport;
        break;
      case NATIONAL_ID_CARD:
        cardSample = KCAssets.ninCard;
        break;
      case DRIVER_LICENSE:
        cardSample = KCAssets.driversLicense;
        break;
      case VOTERS_CARD:
        cardSample = KCAssets.votersCard;
        break;
      default:
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YSpace(30.82),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: checkoutNotfier.prevPage,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            KCAssets.arrowBack,
                            package: KC_PACKAGE_NAME,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Image.network(
                        checkoutNotfier.selectedBankFlow?.logo ?? '',
                        height: 40,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotfier.initiateResponse?.merchant != null)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: KCHeadline4(
                            checkoutNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(16),
                    if (stepData?.displayData?.title != null)
                      KCHeadline3(
                        stepData?.displayData?.title ?? '',
                        fontSize: 20,
                      ),
                    if (stepData?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(24),
                    StreamBuilder<String>(
                      stream: idNumberStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _idNumberCtrl,
                          focusNode: _idNumberFocus,
                          hint: 'ID Number',
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          validationMessage:
                              KCFormValidator.errorMessageIdNumber(
                            snapshot.data,
                            'Enter the ID Number',
                            checkoutNotfier.documentType!,
                          ),
                        );
                      },
                    ),
                    const YSpace(24),
                    GestureDetector(
                      onTap: () => selectDocumentImage(),
                      child: _documentFile != null
                          ? Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(_documentFile!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.60),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        KCAssets.repeat,
                                        package: KC_PACKAGE_NAME,
                                      ),
                                      const XSpace(5),
                                      KCHeadline5(
                                        'Reupload photo',
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(6),
                              color: KCColors.primary,
                              strokeWidth: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: const Color(0XFFF6F9FF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        cardSample,
                                        width: 40,
                                        height: 20,
                                        package: KC_PACKAGE_NAME,
                                      ),
                                      const YSpace(8),
                                      KCHeadline5(
                                        'Only the part with information',
                                        color: KCColors.primary,
                                        fontSize: 12,
                                      ),
                                      const YSpace(8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: KCColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              KCAssets.upload,
                                              package: KC_PACKAGE_NAME,
                                              height: 10,
                                              width: 15,
                                            ),
                                            const XSpace(5),
                                            KCHeadline5(
                                              'Upload Image',
                                              color: Colors.white,
                                              fontSize: 12,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const YSpace(25),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _enabled,
                      builder: (_, enabled, __) {
                        return KCPrimaryButton(
                          title: 'Continue',
                          disabled: !enabled || checkoutNotfier.isBusy,
                          loading: checkoutNotfier.isBusy,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            checkoutNotfier.uploadDocument(
                              idNumber: _idNumberCtrl.text.trim(),
                              file: _documentFile!,
                            );
                          },
                        );
                      },
                    ),
                    const YSpace(59)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
