import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment/GetX/history_getx.dart';
import 'package:payment/GetX/payment_getx.dart';
import 'package:payment/Screen/Bonus%20History.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/services/dummybloc.dart';
import 'package:get/get.dart';

void main() {
  // Create a mock HistoryController
  late HistoryController historyController;

  // Create a mock PaymentController
  late PaymentController paymentController;

  // Create a mock PaymentBloc
  late PaymentBloc paymentBloc;

  // Create a mock StreamController for paymentadmin stream
  late StreamController<List<Payments>> paymentStreamController;

  setUp(() {
    historyController = HistoryController();
    paymentController = PaymentController();
    paymentBloc = PaymentBloc();
    paymentStreamController = StreamController<List<Payments>>();
  });

  tearDown(() {
    paymentStreamController.close();
  });

  testWidgets('History widget test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      GetMaterialApp(
        home: History(),
      ),
    );

    // Verify that the initial date is shown correctly
    expect(find.text('Select Month'), findsOneWidget);
    expect(find.text(historyController.date.value), findsOneWidget);

    // Verify that the total loans given section is empty initially
    expect(find.text('Total Loans given'), findsOneWidget);
    expect(find.text(''), findsOneWidget);

    // Create a mock payment
    final mockPayment = Payments(
      payments_key: 'payment_id',
      category: 'Loans',
    );

    await tester.pump();

    // Verify the updated state of the widget
    expect(find.text(mockPayment.payment), findsNothing);
  });
}
