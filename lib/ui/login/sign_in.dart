import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/ui/login/bloc/sign_in_bloc.dart';
import 'package:nityaassociation/ui/login/phone_in.dart';
import 'package:nityaassociation/ui/signup/sign_up.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextStyle headingStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
  SignInBloc _bloc = SignInBloc();

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc.signInStream.listen((event) {
      print("tag" + event.user.toString());
      if (event.user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => PhoneIn(_phoneController.text)));
      } else {
        AppUtils.showError(event.error, _globalKey);
      }
    });

    _bloc.loadingStream.listen((event) {
      if (context != null) {
        if (event) {
          AppUtils.showLoadingDialog(context);
        } else {
          Navigator.pop(context);
        }
      }
    });

//    _bloc.errorStream.listen((event) {
//      AppUtils.showError(event, _globalKey);
//    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 56,
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    "Sign In",
                    style: headingStyle,
                  ),
                  subtitle: Text("Please enter the details to continue"),
                ),
                SizedBox(
                  height: 48,
                ),
                Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _phoneController,
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.phone,
                            decoration:
                                InputDecoration(labelText: "Mobile Number"),
                            validator: (v) {
                              if (v.isEmpty) {
                                return 'Field is required';
                              } else if (v.length != 10) {
                                return 'Value should be 10 Digits';
                              }

                              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(pattern);

                              if (!regExp.hasMatch(v)) {
                                return 'Please enter valid mobile number';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            color: kPrimaryColor,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _bloc.signIn(_phoneController.text);
                              }
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "You will receive an OTP on the mobile number you entered, for verification.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.50)),
                          )
                        ],
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 196),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SignUp()));
                                },
                              text: "Sign Up",
                              style: TextStyle(color: kPrimaryColor))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
