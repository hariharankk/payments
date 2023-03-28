import 'package:rxdart/rxdart.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/services/Bloc.dart';
import 'package:intl/intl.dart';

class ApprovalBloc {

  final apiProvider1 = apirepository();
  final PublishSubject<List<dynamic>> _approvalGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _approval = [];

  ApprovalBloc._privateConstructor();

  static final ApprovalBloc _instance = ApprovalBloc._privateConstructor();

  factory ApprovalBloc() {
    return _instance;
  }

  Stream<List<dynamic>> get getapproval => _approvalGetter.stream;

  List<dynamic> getUserObject() {
    return _approval;
  }

  Future<void>  approval_getdata() async {
    try {
      _approval = await apiProvider1.approval_getdata();
      _approvalGetter.sink.add(_approval);
    } catch (e) {
      throw e;
    }
  }


  dispose() {
    _approvalGetter.close();
  }
}

final approvalBloc = ApprovalBloc();

class HistoryBloc {

  final apiProvider1 = apirepository();
  final PublishSubject<List<dynamic>> _historyGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _history = [];

  HistoryBloc._privateConstructor();

  static final HistoryBloc _instance = HistoryBloc._privateConstructor();

  factory HistoryBloc() {
    return _instance;
  }

  Stream<List<dynamic>> get gethistory => _historyGetter.stream;

  List<dynamic> getUserObject() {
    return _history;
  }

  Future<void>  history_getdata(String id) async {
    try {
      _history = await apiProvider1.history_getdata(userBloc.getUserObject().username!);
      _historyGetter.sink.add(_history);
    } catch (e) {
      throw e;
    }
  }


  dispose() {
    _historyGetter.close();
  }
}

final historyBloc = HistoryBloc();

class EmpadminBloc {

  final apiProvider1 = apirepository();
  final PublishSubject<List<dynamic>> _empadminGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _empadmin = [];

  EmpadminBloc._privateConstructor();

  static final EmpadminBloc _instance = EmpadminBloc._privateConstructor();

  factory EmpadminBloc() {
    return _instance;
  }

  Stream<List<dynamic>> get getempadmin => _empadminGetter.stream;

  List<dynamic> getUserObject() {
    return _empadmin;
  }

  Future<void>  employeeadmin_getdata() async {
    try {
      _empadmin = await apiProvider1.employeeadmin_getdata();
      _empadminGetter.sink.add(_empadmin);
    } catch (e) {
      throw e;
    }
  }

  Future<void> addemployee(Map<dynamic,dynamic> empMap) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await apiProvider1.employee_uploaddata(empMap);
    await employeeadmin_getdata();
  }



  dispose() {
    print('dispose panni achu da baadu');
    _empadminGetter.close();
  }
}

final empadminBloc = EmpadminBloc();


class PaymentBloc {

  final apiProvider1 = apirepository();
  final PublishSubject<List<dynamic>> _paymentGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _payment = [];


  Stream<List<dynamic>> get paymentadmin => _paymentGetter.stream;

  List<dynamic> getObject() {
    return _payment;
  }

  List<dynamic> _Ledger = [];
  final PublishSubject<List<dynamic>> _LedgerGetter = PublishSubject<List<dynamic>>();
  Stream<List<dynamic>> get Ledgeradmin => _LedgerGetter.stream;

  List<dynamic> getLedger() {
    return _Ledger;
  }


  Future<void>  payment_getdata(String range, String category ,String userid) async {
    try {
      _payment = await apiProvider1.getPayments(range, category , userid);
      _paymentGetter.sink.add(_payment);
    } catch (e) {
      throw e;
    }
  }

  Future<void>  Ledger_getdata(String range,String userid) async {
    try {
      _Ledger = await apiProvider1.getLedgerdata(range,userid);
      print(_Ledger);
      _LedgerGetter.sink.add(_Ledger);
    } catch (e) {
      throw e;
    }
  }


  Future<void> addpayment(Map<dynamic,dynamic> payments) async {
    await apiProvider1.Payments_adddata(payments);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await Ledger_getdata(DateFormat("MMMM, yyyy").format(DateTime.now()), payments['userid']);
  }

  Future<void> deletepayment(String payments, String range, String category ,String userid) async {
    await apiProvider1. payments_delete(payments);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await payment_getdata(range, category , userid);
    await Ledger_getdata(range, userid);
  }



  dispose() {
    print('dispose panni achu da baadu');
    _paymentGetter.close();
  }
}

final ledgerbloc =PaymentBloc();