// Mocks generated by Mockito 5.4.0 from annotations
// in klump_checkout/test/klump_checkout_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:ui' as _i7;

import 'package:flutter/material.dart' as _i5;
import 'package:klump_checkout/src/domain/usecases/accept_terms.dart' as _i4;
import 'package:klump_checkout/src/domain/usecases/account_credentials.dart'
    as _i3;
import 'package:klump_checkout/src/src.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeInitiateTransactionUsecase_0 extends _i1.SmartFake
    implements _i2.InitiateTransactionUsecase {
  _FakeInitiateTransactionUsecase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAccountValidationUsecase_1 extends _i1.SmartFake
    implements _i2.AccountValidationUsecase {
  _FakeAccountValidationUsecase_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeVerifyOTPUsecase_2 extends _i1.SmartFake
    implements _i2.VerifyOTPUsecase {
  _FakeVerifyOTPUsecase_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetBankTCUsecase_3 extends _i1.SmartFake
    implements _i2.GetBankTCUsecase {
  _FakeGetBankTCUsecase_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetRepaymentDetailsUsecase_4 extends _i1.SmartFake
    implements _i2.GetRepaymentDetailsUsecase {
  _FakeGetRepaymentDetailsUsecase_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCreateNewUsecase_5 extends _i1.SmartFake
    implements _i2.CreateNewUsecase {
  _FakeCreateNewUsecase_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetLoanStatusUsecase_6 extends _i1.SmartFake
    implements _i2.GetLoanStatusUsecase {
  _FakeGetLoanStatusUsecase_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetPartnerInsurersUsecase_7 extends _i1.SmartFake
    implements _i2.GetPartnerInsurersUsecase {
  _FakeGetPartnerInsurersUsecase_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAccountCredentialsUsecase_8 extends _i1.SmartFake
    implements _i3.AccountCredentialsUsecase {
  _FakeAccountCredentialsUsecase_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetLoanPartnersUsecase_9 extends _i1.SmartFake
    implements _i2.GetLoanPartnersUsecase {
  _FakeGetLoanPartnersUsecase_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAcceptTermsUsecase_10 extends _i1.SmartFake
    implements _i4.AcceptTermsUsecase {
  _FakeAcceptTermsUsecase_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePageController_11 extends _i1.SmartFake
    implements _i5.PageController {
  _FakePageController_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [KCChangeNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockKCChangeNotifier extends _i1.Mock implements _i2.KCChangeNotifier {
  MockKCChangeNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.InitiateTransactionUsecase get initiateTransactionUsecase =>
      (super.noSuchMethod(
        Invocation.getter(#initiateTransactionUsecase),
        returnValue: _FakeInitiateTransactionUsecase_0(
          this,
          Invocation.getter(#initiateTransactionUsecase),
        ),
      ) as _i2.InitiateTransactionUsecase);

  @override
  set initiateTransactionUsecase(
          _i2.InitiateTransactionUsecase? _initiateTransactionUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #initiateTransactionUsecase,
          _initiateTransactionUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.AccountValidationUsecase get accountValidationUsecase =>
      (super.noSuchMethod(
        Invocation.getter(#accountValidationUsecase),
        returnValue: _FakeAccountValidationUsecase_1(
          this,
          Invocation.getter(#accountValidationUsecase),
        ),
      ) as _i2.AccountValidationUsecase);

  @override
  set accountValidationUsecase(
          _i2.AccountValidationUsecase? _accountValidationUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #accountValidationUsecase,
          _accountValidationUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.VerifyOTPUsecase get verifyOTPUsecase => (super.noSuchMethod(
        Invocation.getter(#verifyOTPUsecase),
        returnValue: _FakeVerifyOTPUsecase_2(
          this,
          Invocation.getter(#verifyOTPUsecase),
        ),
      ) as _i2.VerifyOTPUsecase);

  @override
  set verifyOTPUsecase(_i2.VerifyOTPUsecase? _verifyOTPUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #verifyOTPUsecase,
          _verifyOTPUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GetBankTCUsecase get getBankTCUsecase => (super.noSuchMethod(
        Invocation.getter(#getBankTCUsecase),
        returnValue: _FakeGetBankTCUsecase_3(
          this,
          Invocation.getter(#getBankTCUsecase),
        ),
      ) as _i2.GetBankTCUsecase);

  @override
  set getBankTCUsecase(_i2.GetBankTCUsecase? _getBankTCUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #getBankTCUsecase,
          _getBankTCUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GetRepaymentDetailsUsecase get getRepaymentDetailsUsecase =>
      (super.noSuchMethod(
        Invocation.getter(#getRepaymentDetailsUsecase),
        returnValue: _FakeGetRepaymentDetailsUsecase_4(
          this,
          Invocation.getter(#getRepaymentDetailsUsecase),
        ),
      ) as _i2.GetRepaymentDetailsUsecase);

  @override
  set getRepaymentDetailsUsecase(
          _i2.GetRepaymentDetailsUsecase? _getRepaymentDetailsUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #getRepaymentDetailsUsecase,
          _getRepaymentDetailsUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.CreateNewUsecase get createNewUsecase => (super.noSuchMethod(
        Invocation.getter(#createNewUsecase),
        returnValue: _FakeCreateNewUsecase_5(
          this,
          Invocation.getter(#createNewUsecase),
        ),
      ) as _i2.CreateNewUsecase);

  @override
  set createNewUsecase(_i2.CreateNewUsecase? _createNewUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #createNewUsecase,
          _createNewUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GetLoanStatusUsecase get getLoanStatusUsecase => (super.noSuchMethod(
        Invocation.getter(#getLoanStatusUsecase),
        returnValue: _FakeGetLoanStatusUsecase_6(
          this,
          Invocation.getter(#getLoanStatusUsecase),
        ),
      ) as _i2.GetLoanStatusUsecase);

  @override
  set getLoanStatusUsecase(_i2.GetLoanStatusUsecase? _getLoanStatusUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #getLoanStatusUsecase,
          _getLoanStatusUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GetPartnerInsurersUsecase get getPartnerInsurersUsecase =>
      (super.noSuchMethod(
        Invocation.getter(#getPartnerInsurersUsecase),
        returnValue: _FakeGetPartnerInsurersUsecase_7(
          this,
          Invocation.getter(#getPartnerInsurersUsecase),
        ),
      ) as _i2.GetPartnerInsurersUsecase);

  @override
  set getPartnerInsurersUsecase(
          _i2.GetPartnerInsurersUsecase? _getPartnerInsurersUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #getPartnerInsurersUsecase,
          _getPartnerInsurersUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.AccountCredentialsUsecase get accountCredentialsUsecase =>
      (super.noSuchMethod(
        Invocation.getter(#accountCredentialsUsecase),
        returnValue: _FakeAccountCredentialsUsecase_8(
          this,
          Invocation.getter(#accountCredentialsUsecase),
        ),
      ) as _i3.AccountCredentialsUsecase);

  @override
  set accountCredentialsUsecase(
          _i3.AccountCredentialsUsecase? _accountCredentialsUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #accountCredentialsUsecase,
          _accountCredentialsUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.GetLoanPartnersUsecase get getLoanPartnersUsecase => (super.noSuchMethod(
        Invocation.getter(#getLoanPartnersUsecase),
        returnValue: _FakeGetLoanPartnersUsecase_9(
          this,
          Invocation.getter(#getLoanPartnersUsecase),
        ),
      ) as _i2.GetLoanPartnersUsecase);

  @override
  set getLoanPartnersUsecase(
          _i2.GetLoanPartnersUsecase? _getLoanPartnersUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #getLoanPartnersUsecase,
          _getLoanPartnersUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.AcceptTermsUsecase get acceptTermsUsecase => (super.noSuchMethod(
        Invocation.getter(#acceptTermsUsecase),
        returnValue: _FakeAcceptTermsUsecase_10(
          this,
          Invocation.getter(#acceptTermsUsecase),
        ),
      ) as _i4.AcceptTermsUsecase);

  @override
  set acceptTermsUsecase(_i4.AcceptTermsUsecase? _acceptTermsUsecase) =>
      super.noSuchMethod(
        Invocation.setter(
          #acceptTermsUsecase,
          _acceptTermsUsecase,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isLive => (super.noSuchMethod(
        Invocation.getter(#isLive),
        returnValue: false,
      ) as bool);

  @override
  bool get isBusy => (super.noSuchMethod(
        Invocation.getter(#isBusy),
        returnValue: false,
      ) as bool);

  @override
  int get currentPage => (super.noSuchMethod(
        Invocation.getter(#currentPage),
        returnValue: 0,
      ) as int);

  @override
  _i5.PageController get pageController => (super.noSuchMethod(
        Invocation.getter(#pageController),
        returnValue: _FakePageController_11(
          this,
          Invocation.getter(#pageController),
        ),
      ) as _i5.PageController);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  void nextPage() => super.noSuchMethod(
        Invocation.method(
          #nextPage,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void prevPage() => super.noSuchMethod(
        Invocation.method(
          #prevPage,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setTransactionData(
    bool? isLive,
    _i2.KlumpCheckoutData? data,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #setTransactionData,
          [
            isLive,
            data,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setBankFlow(_i2.Partner? bank) => super.noSuchMethod(
        Invocation.method(
          #setBankFlow,
          [bank],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void selectBank(Map<String, dynamic>? bank) => super.noSuchMethod(
        Invocation.method(
          #selectBank,
          [bank],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setPaymentSplit(int? split) => super.noSuchMethod(
        Invocation.method(
          #setPaymentSplit,
          [split],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setPaymentDay(int? day) => super.noSuchMethod(
        Invocation.method(
          #setPaymentDay,
          [day],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setPartnerInsurer(_i2.PartnerInsurer? insurer) => super.noSuchMethod(
        Invocation.method(
          #setPartnerInsurer,
          [insurer],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Future<bool> initiateTransaction({
    required String? email,
    required String? phone,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #initiateTransaction,
          [],
          {
            #email: email,
            #phone: phone,
          },
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);

  @override
  _i6.Future<void> getLoanPartners() => (super.noSuchMethod(
        Invocation.method(
          #getLoanPartners,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> validateAccount(
    String? accountNumber,
    String? phoneNumber, {
    String? firstName,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #validateAccount,
          [
            accountNumber,
            phoneNumber,
          ],
          {#firstName: firstName},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<bool> resendAccountOTP() => (super.noSuchMethod(
        Invocation.method(
          #resendAccountOTP,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);

  @override
  _i6.Future<void> verifyOTP(
    String? otp,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #verifyOTP,
          [
            otp,
            password,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> fetchBankTC() => (super.noSuchMethod(
        Invocation.method(
          #fetchBankTC,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> getRepaymentDetails(
    int? installment,
    int? repaymentDay,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRepaymentDetails,
          [
            installment,
            repaymentDay,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> createLoan() => (super.noSuchMethod(
        Invocation.method(
          #createLoan,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i2.DisbursementStatusResponse?> getLoanStatus() =>
      (super.noSuchMethod(
        Invocation.method(
          #getLoanStatus,
          [],
        ),
        returnValue: _i6.Future<_i2.DisbursementStatusResponse?>.value(),
      ) as _i6.Future<_i2.DisbursementStatusResponse?>);

  @override
  _i6.Future<void> getPartnerInsurer() => (super.noSuchMethod(
        Invocation.method(
          #getPartnerInsurer,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> addAccountCredentials(
    String? email,
    String? password,
    DateTime? dob,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addAccountCredentials,
          [
            email,
            password,
            dob,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> acceptTerms() => (super.noSuchMethod(
        Invocation.method(
          #acceptTerms,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
