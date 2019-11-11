import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:yogurt/selection.dart';
import 'Colors.dart';

class Home extends StatelessWidget {
  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      
      body: Container(
          alignment: Alignment(0.0, -1.0),
          color: THEME_COLOR,
          child: Padding(
            padding: new EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      new EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
                ),
                Image(
                  image: AssetImage('assets/yogurtIcon.png'),
                  height: 45,
                  width: 45,
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 3),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Order",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                    TypewriterAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        "Yogurt",
                      ],
                      textStyle: TextStyle(
                          fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      new EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register()));
                  },
                  height: 56,
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  color: THEME_COLOR,
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(color: WHITE),
                  ),
                  elevation: 2,
                  highlightColor: THEME_COLOR,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: WHITE)),
                ),
                Padding(
                  padding: new EdgeInsets.only(top: 20),
                ),
                MaterialButton(
                  onPressed: () {
                    
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                        
                  },
                  height: 56,
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  color: WHITE,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: THEME_COLOR),
                  ),
                  elevation: 2,
                  highlightColor: WHITE.withOpacity(0.24),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: THEME_COLOR)),
                ),
              ],
            ),
          )),
    );
  }
}

class Login extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginState createState() => _LoginState();
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UserAlreadyExists }
authProblems errorType;

class _LoginState extends State<Login> {
  bool _validate = false;

  final _formKey = GlobalKey<FormState>();
  final myControllerLogin = TextEditingController();
  final myControllerPass = TextEditingController();

  FirebaseUser user;

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    myControllerLogin.dispose();
    myControllerPass.dispose();
    super.dispose();
  }

  // Initialize Firebase Auth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment(0.0, -1.0),
          color: WHITE.withOpacity(0.4),
          child: Padding(
            padding: new EdgeInsets.only(left: 30, right: 30),
            child: new Form(
              key: _formKey,
              autovalidate: _validate,
              child: _getFormData(),
            ),
          )),
    );
  }

  Widget _getFormData() {
    final emailLogin = TextFormField(
      decoration: InputDecoration(
        hintText: "john.wick@gmail.com",
        hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        hintMaxLines: 15,
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: THEME_COLOR),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.start,
      cursorColor: THEME_COLOR,
      cursorRadius: Radius.circular(2.0),
      cursorWidth: 2.0,
      validator: FormValidatorLogin().validateEmail,
      controller: myControllerLogin,
    );
    final passLogin = TextFormField(
      decoration: InputDecoration(
        hintText: "***********",
        hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        hintMaxLines: 15,
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: THEME_COLOR),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.text,
      autocorrect: false,
      cursorColor: Colors.black,
      cursorRadius: Radius.circular(2.0),
      cursorWidth: 2.0,
      obscureText: true,
      validator: FormValidatorLogin().validatePassword,
      controller: myControllerPass,
    );

    return ListView(
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        ),
        GestureDetector(
          onTap: () {
            //Easter Egg to add <==============
          },
          child: Image(
            image: AssetImage('assets/yogurtIcon.png'),
            height: 45,
            width: 45,
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "EMAIL",
            style:
                TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        emailLogin,
        Padding(
          padding: new EdgeInsets.only(top: 20),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "PASSWORD",
            style:
                TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        passLogin,
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: new EdgeInsets.only(top: 7),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPass()));
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold),
                ),
              ),
            )),
        Padding(
          padding: new EdgeInsets.only(top: 20),
        ),
        MaterialButton(
          onPressed: () {
            _sendToServerLogin(myControllerLogin.text, myControllerPass.text);
          },
          height: 56,
          minWidth: MediaQuery.of(context).size.width / 1.2,
          color: THEME_COLOR,
          child: Text(
            "LOGIN",
            style: TextStyle(color: WHITE),
          ),
          elevation: 2,
          highlightColor: THEME_COLOR,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: THEME_COLOR)),
        ),
      ],
    );
  }

  Future<void> _sendToServerLogin(String _email, String _pass) async {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      try {
        user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _pass);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderList(user)));
      } catch (e) {
        //print(e.message);
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            break;
        }

        print(errorType);
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

class FormValidatorLogin {
  String validatePassword(String value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Password is Required";
    } else if (value.length < 8) {
      return "Password must minimum eight characters";
    } else if (!regExp.hasMatch(value)) {
      return "Password at least one uppercase letter, one lowercase letter and one number";
    } else {
      return null;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }
}

class Register extends StatefulWidget {
  static const String routeName = "/register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  final myControllerPassC = TextEditingController();

  FirebaseUser user;

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    myControllerEmail.dispose();
    myControllerPass.dispose();
    myControllerPassC.dispose();
    super.dispose();
  }

  // Initialize Firebase Auth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: Container(
          alignment: Alignment(0.0, -1.0),
          color: WHITE.withOpacity(0.4),
          child: Padding(
            padding: new EdgeInsets.only(left: 30, right: 30),
            child: new Form(
              key: _formKey,
              autovalidate: _validate,
              child: _getFormData(),
            ),
          )),
    );
  }

  Widget _getFormData() {
    final emailRegister = TextFormField(
      decoration: InputDecoration(
        hintText: "john.wick@gmail.com",
        hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        hintMaxLines: 15,
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: THEME_COLOR),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.start,
      cursorColor: THEME_COLOR,
      cursorRadius: Radius.circular(2.0),
      cursorWidth: 2.0,
      validator: FormValidatorRegister().validateEmail,
      controller: myControllerEmail,
    );
    final passRegister = TextFormField(
      decoration: InputDecoration(
        hintText: "***********",
        hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        hintMaxLines: 15,
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: THEME_COLOR),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.text,
      autocorrect: false,
      cursorColor: Colors.black,
      cursorRadius: Radius.circular(2.0),
      cursorWidth: 2.0,
      obscureText: true,
      validator: FormValidatorRegister().validatePassword,
      controller: myControllerPass,
    );
    final passRegisterConfirmation = TextFormField(
      decoration: InputDecoration(
        hintText: "***********",
        hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        hintMaxLines: 15,
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: THEME_COLOR),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.text,
      autocorrect: false,
      cursorColor: Colors.black,
      cursorRadius: Radius.circular(2.0),
      cursorWidth: 2.0,
      obscureText: true,
      validator: FormValidatorRegister().validatePassword2,
      controller: myControllerPassC,
    );

    return ListView(
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        ),
        GestureDetector(
          onTap: () {
            //Easter Egg to add <==============
          },
          child: Image(
            image: AssetImage('assets/yogurtIcon.png'),
            height: 45,
            width: 45,
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).size.height / 9.5),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "EMAIL",
            style:
                TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        emailRegister,
        Padding(
          padding: new EdgeInsets.only(top: 20),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "PASSWORD",
            style:
                TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        passRegister,
        Padding(
          padding: new EdgeInsets.only(top: 20),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "CONFIRM PASSWORD",
            style:
                TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        passRegisterConfirmation,
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: new EdgeInsets.only(top: 7),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  "Already have an account?",
                  style: TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold),
                ),
              ),
            )),
        Padding(
          padding: new EdgeInsets.only(top: 20),
        ),
        MaterialButton(
          onPressed: () {
            _sendToServerRegister(
                myControllerEmail.text, myControllerPass.text, myControllerPassC.text);
          },
          height: 56,
          minWidth: MediaQuery.of(context).size.width / 1.2,
          color: THEME_COLOR,
          child: Text(
            "SIGN UP",
            style: TextStyle(color: WHITE),
          ),
          elevation: 2,
          highlightColor: THEME_COLOR,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: THEME_COLOR)),
        ),
      ],
    );
  }

  Future<void> _sendToServerRegister(
      String _email, String _pass, String _passConfirm) async {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      try {
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _pass,
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderList(user)));
      } catch (e) {
        //print(e.message);
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            break;
          case 'The email address is already in use by another account.':
            errorType = authProblems.UserAlreadyExists;
        }
        print(errorType);
      }
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

class FormValidatorRegister {
  static var value1 = "";

  String validatePassword(String value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Password is Required";
    } else if (value.length < 8) {
      return "Password must minimum eight characters";
    } else if (!regExp.hasMatch(value)) {
      return "Password at least one uppercase letter, one lowercase letter and one number";
    } else {
      value1 = value;
      return null;
    }
  }

  String validatePassword2(String value) {
    if (value.isEmpty) {
      return "Confirmation is Required";
    } else if (value1 != value) {
      return "The passwords are not the same";
    } else {
      return null;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }
}

class LoginRequestData {
  String email = '';
  String password = '';

  String get _email {
    return email;
  }

  void set _email(String email) {
    this.email = email;
  }

  String get _password {
    return password;
  }

  void set _password(String password) {
    this.password = password;
  }
}

class RegisterRequestData {
  String email = '';
  String password = '';
  String passwordconfirm = '';

  String get _email {
    return email;
  }

  void set _email(String email) {
    this.email = email;
  }

  String get _password {
    return password;
  }

  void set _password(String password) {
    this.password = password;
  }

  String get _passwordConfirm {
    return passwordconfirm;
  }

  void set _passwordConfirm(String passwordconfirm) {
    this..passwordconfirm = passwordconfirm;
  }
}

class EnterExitRouteRight extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  EnterExitRouteRight({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
                children: <Widget>[
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(-1.0, 0.0),
                    ).animate(animation),
                    child: exitPage,
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: enterPage,
                  )
                ],
              ),
        );
}

class EnterExitRouteLeft extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  EnterExitRouteLeft({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
                children: <Widget>[
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 0.0),
                    ).animate(animation),
                    child: exitPage,
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: enterPage,
                  )
                ],
              ),
        );
}

class ResetPass extends StatefulWidget {
  static const String routeName = "/reset";

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  static FirebaseAuth user;
  final myControllerEmail = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myControllerEmail.dispose();
    
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          alignment: Alignment(0.0, -1.0),
          color: WHITE.withOpacity(0.4),
          child: Padding(
            padding: new EdgeInsets.only(left: 30, right: 30),
            child: new Form(
              key: _formKey,
              child: _getFormData(),
            ),
          )),
    );
  }

  Widget _getFormData() {
    final emailReset = TextFormField(
      decoration: InputDecoration(
        hintText: "john.wick@gmail.com",
        hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        hintMaxLines: 15,
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: THEME_COLOR),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.start,
      cursorColor: THEME_COLOR,
      cursorRadius: Radius.circular(2.0),
      cursorWidth: 2.0,
      controller: myControllerEmail,
      validator: FormValidatorReset().validateEmailNotNull,
    );
    return ListView(
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        ),
        GestureDetector(
          onTap: () {
            //Easter Egg to add <==============
          },
          child: Image(
            image: AssetImage('assets/yogurtIcon.png'),
            height: 45,
            width: 45,
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "EMAIL",
            style:
                TextStyle(color: THEME_COLOR, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        emailReset,
        Padding(
          padding: new EdgeInsets.only(top: 20),
        ),
        MaterialButton(
          onPressed: () {
            resetPassword(myControllerEmail.text);
          },
          height: 56,
          minWidth: MediaQuery.of(context).size.width / 1.2,
          color: THEME_COLOR,
          child: Text(
            "RESET PASSWORD",
            style: TextStyle(color: WHITE),
          ),
          elevation: 2,
          highlightColor: THEME_COLOR,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: THEME_COLOR)),
        ),
      ],
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<void> resetPassword(String email) async {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      if (email.isNotEmpty) {
        try {
          await user.sendPasswordResetEmail(email: email);
          showInSnackBar("Password reset email was sent. Check your inbox.");
          
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        } catch (e) {}
      }
    }
  }
}

class FormValidatorReset {
  String validateEmailNotNull(String value) {
    if (value.isEmpty) {
      return "Email is required";
    } else {
      return null;
    }
  }
}
