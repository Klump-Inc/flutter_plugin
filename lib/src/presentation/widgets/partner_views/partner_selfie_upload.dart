import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerSelfieUpload extends StatefulWidget {
  const PartnerSelfieUpload({super.key});

  @override
  State<PartnerSelfieUpload> createState() => _PartnerSelfieUploadState();
}

class _PartnerSelfieUploadState extends State<PartnerSelfieUpload> {
  late CameraController _cameraController;
  bool _cameraReady = false;
  VerificationStep _step = VerificationStep.start;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      cameras[1],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraReady = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Logger().d('User denied camera access.');
            break;
          default:
            Logger().d(e.description);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.nextStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
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
                    Align(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height:
                            (283 * (constraints.maxHeight < 670 ? 0.70 : 1)) +
                                (_step == VerificationStep.capture ||
                                        _step == VerificationStep.preview
                                    ? 75
                                    : 0),
                        width:
                            (214 * (constraints.maxHeight < 670 ? 0.70 : 1)) +
                                (_step == VerificationStep.capture ||
                                        _step == VerificationStep.preview
                                    ? 85
                                    : 0),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: (_step == VerificationStep.capture ||
                                _step == VerificationStep.preview)
                            ? null
                            : BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.elliptical(290, 383),
                                ),
                                border: Border.all(color: KCColors.primary),
                              ),
                        child: (_step == VerificationStep.capture ||
                                _step == VerificationStep.preview)
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CameraPreview(_cameraController),
                                  Image.asset(
                                    KCAssets.selfieOverlay,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    package: KC_PACKAGE_NAME,
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    KCAssets.selfie,
                                    package: KC_PACKAGE_NAME,
                                  ),
                                  const YSpace(8.52),
                                  KCBodyText1(
                                    'Please frame your face \nto fit this circle',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                      ),
                    ),
                    AnimatedContainer(
                      width: double.infinity,
                      duration: const Duration(milliseconds: 300),
                      child: _step != VerificationStep.preview
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                YSpace(_step == VerificationStep.capture ||
                                        _step == VerificationStep.preview
                                    ? 0
                                    : 24.75),
                                const Icon(
                                  Icons.info,
                                  color: KCColors.primary,
                                  size: 13,
                                ),
                                const YSpace(4.75),
                                KCHeadline5(
                                  'Please make sure your face is visible',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                    const YSpace(25),
                    const Spacer(),
                    KCPrimaryButton(
                      title: _step == VerificationStep.start
                          ? 'Get Started'
                          : _step == VerificationStep.capture
                              ? 'Capture'
                              : 'Use Image',
                      onTap: () {
                        if (_step == VerificationStep.start && _cameraReady) {
                          setState(() {
                            _step = VerificationStep.capture;
                          });
                        } else if (_step == VerificationStep.capture) {
                          _cameraController.takePicture().then((value) {
                            _filePath = value.path;
                            _cameraController.pausePreview().then(
                              (_) {
                                setState(() {
                                  _step = VerificationStep.preview;
                                });
                              },
                            );
                          });
                        } else if (_step == VerificationStep.preview &&
                            _filePath != null) {
                          // onboardNot.validatePassport(
                          //   context,
                          //   filePath: _filePath!,
                          // );
                        }
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

enum VerificationStep {
  start,
  capture,
  preview;
}
