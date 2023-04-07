import 'package:flutter/material.dart';
import 'package:payment/services/authentication.dart';
import 'package:payment/models/user.dart';
import 'package:payment/ui/alreadyhaveaaccount.dart';
import 'package:payment/ui/login_page.dart';
import 'package:payment/services/validate.dart';
import 'package:payment/services/Bloc.dart';
import 'package:get/get.dart';

class register extends StatefulWidget {
  final VoidCallback loginCallback;
  register({required this.loginCallback});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  Auth auth = Auth();
  late String _email;
  late String _password;
  late String _name;
  late String _phoneNumber;
  String _errorMessage = '';
  bool _isLoading = false;

  void registeradmin() async{
    setState(() {
      _isLoading = true;
    });
    try {
    User user = User(phonenumber: _phoneNumber,email: _email,admin: true, password: _password, name: _name);
    Map<dynamic, dynamic> userdata = user.toMap();
    await userBloc.registerUser(userdata);

      setState(() {
        _isLoading = false;
      });
      await Get.to(()=> LoginPage(loginCallback: widget.loginCallback));

      Get.back();
    }
    catch(e){
      setState(() {
        _isLoading = false;
        _errorMessage ='Unable to register, because your phonenumber and mobile number not unique';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              //showLogo(),
              NameInput(),
              showEmailInput(),
              showPasswordInput(),
              showPhoneInput(),
              SizedBox(
                height: 10.0,
              ),
              showErrorMessage(_errorMessage),
              showPrimaryButton(),
              SizedBox(
                height: 15.0,
              ),
              AlreadyHaveAnAccountCheck(login: false,
                press: () async{
                 await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage(loginCallback: widget.loginCallback);
                      },
                    ),
                  );
                 Navigator.pop(context);
                },
              ),
            ],
          ),
        )
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showErrorMessage(String text) {
    if (text.length > 0 && text != null) {
      return new Text(
        text,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.jpg'),
        ),
      ),
    );
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: false,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "Please enter your Phone Number",
          icon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
        value!.isEmpty
            ? 'Number can\'t be empty'
            : new Validate().verfiyMobile(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Please enter your Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Password can\'t be empty' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Please enter your Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
        onChanged: (value) => _email = value.trim(),
      ),
    );
  }


  Widget NameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Please enter your Name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'Name can\'t be empty' : null,
        onChanged: (value) => _name = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new ElevatedButton(
          // elevation: 5.0,
          // shape: new RoundedRectangleBorder(
          //     borderRadius: new BorderRadius.circular(30.0)),
          // color: Colors.blue,
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)
            )
          ),
          child: new Text('Register',
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: ()
          async{
            registeradmin();
          },
        ),
      ),
    );
  }
}