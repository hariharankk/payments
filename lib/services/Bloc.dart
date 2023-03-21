import 'package:rxdart/rxdart.dart';
import 'package:payment/models/user.dart';
import 'package:payment/services/Repository.dart';

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
      _user = await repository.signinUser(phone, verificationId);
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

final userBloc = UserBloc();