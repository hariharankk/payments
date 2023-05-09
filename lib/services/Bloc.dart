import 'package:rxdart/rxdart.dart';
import 'package:payment/models/user.dart';
import 'package:payment/services/Repository.dart';
import 'package:payment/models/store.dart';

class UserBloc {
  final PublishSubject<User> _userGetter = PublishSubject<User>();
  User _user = new User.blank();

  UserBloc._privateConstructor();

  static final UserBloc _instance = UserBloc._privateConstructor();

  factory UserBloc() {
    return _instance;
  }

  Stream<User> get getUser => _userGetter.stream;

  User getUserObject() {
    return _user;
  }

  Future<void> registerUser(Map<dynamic,dynamic> user) async {
    try {
      _user = await repository.registerUser(user);

      _userGetter.sink.add(_user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> emailsigninUser(
      String email, String password) async {
    try {
      _user = await repository.signinUser(email, password);
      _userGetter.sink.add(_user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> phonesigninUser(
      String phone, String verificationId) async {
    try {
      _user = await repository.phonesigninUser(phone, verificationId);
      _userGetter.sink.add(_user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> currentuser() async {
    try {
      _user = await repository.currentuser();
      _userGetter.sink.add(_user);
    } catch (e) {
      throw e;
    }
  }



  dispose() {
    _userGetter.close();
  }
}



class StoreBloc {
  final PublishSubject<List<dynamic>> _storeGetter = PublishSubject<List<dynamic>>();
  List<dynamic> _store = [Store.blank()];

  StoreBloc._privateConstructor();

  static final StoreBloc _instance = StoreBloc._privateConstructor();

  factory StoreBloc() {
    return _instance;
  }

  Stream<List<dynamic>> get getStore => _storeGetter.stream;

  List<dynamic> getUserObject() {
    return _store;
  }

  Future<void>  updateStore() async {
    try {
      _store = await repository.store_getdata(userBloc.getUserObject().username!);
      _storeGetter.sink.add(_store);
    } catch (e) {
      throw e;
    }
  }

  Future<void> addStore(Map<dynamic,dynamic> store) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await repository.addStore(store);
    await updateStore();
  }


  dispose() {
    _storeGetter.close();
  }
}





final userBloc = UserBloc();

final storeBloc = StoreBloc();