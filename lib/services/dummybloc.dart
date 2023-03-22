import 'package:rxdart/rxdart.dart';
import 'package:payment/services/firebase_service.dart';
import 'package:payment/services/Bloc.dart';

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


  dispose() {
    _empadminGetter.close();
  }
}

final empadminBloc = EmpadminBloc();