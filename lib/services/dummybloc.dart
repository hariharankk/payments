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


class ShiftBloc {

  final apiProvider1 = apirepository();
  final PublishSubject<List<dynamic>> _ShiftGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _Shift = [];

  ShiftBloc._privateConstructor();

  static final ShiftBloc _instance = ShiftBloc._privateConstructor();

  factory ShiftBloc() {
    return _instance;
  }

  Stream<List<dynamic>> get getShift => _ShiftGetter.stream;

  List<dynamic> getUserShift() {
    return _Shift;
  }

  Future<void>  Shift_getdata(String id) async {
    try {
      _Shift = await apiProvider1.getShifts(id);
      _ShiftGetter.sink.add(_Shift);
    } catch (e) {
      throw e;
    }
  }

  Future<void> addShift(DateTime date, String type_of_shift ,String userid) async {
    await apiProvider1.Shifts_adddata(date,type_of_shift,userid);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await Shift_getdata(userid);
  }


  dispose() {
    _ShiftGetter.close();
  }
}

final shiftBloc = ShiftBloc();



class LeaveBloc {

  final apiProvider1 = apirepository();
  final PublishSubject<List<dynamic>> _LeaveGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _Leave = [];

  LeaveBloc._privateConstructor();

  static final LeaveBloc _instance = LeaveBloc._privateConstructor();

  factory LeaveBloc() {
    return _instance;
  }

  Stream<List<dynamic>> get getLeave => _LeaveGetter.stream;

  List<dynamic> getUserShift() {
    return _Leave;
  }

  Future<void>  leave_getdata() async {
    try {
      _Leave = await apiProvider1.getleave();
      _LeaveGetter.sink.add(_Leave);
    } catch (e) {
      throw e;
    }
  }

  Future<void>  Leave_adddata(Map<dynamic,dynamic> data) async {
    try {
      await apiProvider1.leave_adddata(data);
    } catch (e) {
      throw e;
    }
  }



  Future<void> Leavedelete(String userid) async {
    await apiProvider1.leave_delete(userid);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await leave_getdata();
  }


  dispose() {
    _LeaveGetter.close();
  }
}

final leaveBloc = LeaveBloc();



