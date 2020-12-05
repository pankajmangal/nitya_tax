import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/ui/common/completed.dart';
import 'package:nityaassociation/ui/login/bloc/verify_login_otp.dart';
import 'package:nityaassociation/ui/login/sign_in.dart';
import 'package:nityaassociation/ui/signup/bloc/resend_bloc.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/prefs_helper.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneIn extends StatefulWidget {
  final String phone;

  PhoneIn(this.phone);

  @override
  _PhoneInState createState() => _PhoneInState();
}

class _PhoneInState extends State<PhoneIn> {
  final TextStyle headingStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final VerifyLoadingOtp _bloc = VerifyLoadingOtp();

  final ResendBloc _resendBloc = ResendBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenOtp();

    _bloc.signInStream.listen((user) {
      PrefsHelper.saveUser(user.accessToken);
      AppUtils.currentUser = user;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Completed()));
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

    _bloc.errorStream.listen((event) {
      AppUtils.showError(event.errorCode.toString(), _scaffoldKey);
    });

    _resendBloc.resendStream.listen((event) {
      startTimer();
      AppUtils.showError(event, _scaffoldKey);
    });

    _resendBloc.loadingStream.listen((event) {
      if (event) {
        AppUtils.showLoadingDialog(context);
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
    _timer?.cancel();
  }

  _listenOtp() async {
    await SmsAutoFill()?.listenForCode;
  }

  String smsCode = '';

  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    "Enter OTP",
                    style: headingStyle,
                  ),
                  subtitle: Text(
                      "Enter the OTP sent to your registered mobile number"),
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
                          TextFieldPinAutoFill(
                              decoration: InputDecoration(
                                labelText: "OTP",
                              ),
                              onCodeSubmitted: (code) {},
                              //code submitted callback
                              onCodeChanged: (code) {
                                smsCode = code ?? '';
                                if (code?.length == 4) {
                                  _bloc.verifyLoginOtp(code, widget.phone);
                                }
                              },
                              //code changed callback
                              codeLength: 4 //code length, default 6
                              ),
                          SizedBox(
                            height: 24,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            color: kPrimaryColor,
                            onPressed: () {
                              if (smsCode.isNotEmpty) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Completed()));
                              }
                            },
                            child: Text(
                              "Verify",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Resend in',
                                style: TextStyle(fontSize: 12),
                              ),
                              _start == 0
                                  ? InkWell(
                                      onTap: () {
                                        _resendBloc.resendOtp(widget.phone, 1);
                                      },
                                      child: Text("Resend"))
                                  : Text(
                                      "timer",
                                      style: TextStyle(
                                          fontSize: 12, color: kPrimaryColor),
                                    )
                            ],
                          )
                        ],
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 196),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SignIn()));
                                },
                              text: "Sign In",
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
