// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpKlumpWidget on WidgetTester {
  Future<void> pumpKCWidget(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [],
        home: Scaffold(
          body: Container(child: widget),
        ),
      ),
    );
  }

  Future<void> pumpKCScreen(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [],
        home: widget,
      ),
    );
  }
}
