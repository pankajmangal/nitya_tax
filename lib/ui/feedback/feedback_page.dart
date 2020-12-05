import 'package:flutter/material.dart';
import 'package:nityaassociation/model/feedback.dart' as feed;
import 'package:nityaassociation/ui/common/notification_app_bar.dart';
import 'package:nityaassociation/ui/feedback/bloc/feedback_bloc.dart';
import 'package:nityaassociation/ui/feedback/thank_you_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';

class FeedbackPage extends StatefulWidget {
  final String title;
  final int id;

  FeedbackPage({this.title, this.id});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  FeedbackBloc _bloc = FeedbackBloc();

  int stackIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.feedbackStream.listen((event) {
      print(event);
      if (event) {
        setState(() {
          stackIndex = 1;
        });
      } else {
        setState(() {
          stackIndex = 2;
        });
      }
    });

    _bloc.loadingStream.listen((event) {
      if (event) {
        AppUtils.showLoadingDialog(context);
      } else {
        Navigator.pop(context);
      }
    });

    _bloc.errorStream.listen((event) {
      setState(() {
        stackIndex = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        child: NotificationAppBar("Feedback/Query"),
        preferredSize: Size.fromHeight(56),
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: IndexedStack(
        index: stackIndex,
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          buildNameContainer(),
                          SizedBox(
                            height: 8,
                          ),
                          buildPhoneContainer(),
                          SizedBox(
                            height: 8,
                          ),
                          buildEmailContainer(),
                          SizedBox(
                            height: 8,
                          ),
                          buildQueryContainer(),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.maxFinite,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              color: kPrimaryColor,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  feed.Feedback feedback = feed.Feedback(
                                      accessToken:
                                          AppUtils.currentUser.accessToken,
                                      name: _nameController.text,
                                      phoneNo: _phoneController.text,
                                      message: _feedbackController.text,
                                      email: _emailController.text,
                                      title: widget.title,
                                      postId: widget.id);
                                  _bloc.postFeedback(feedback);
                                }
                              },
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          FeedThankPage(),
          Container(
            child: Column(
              children: <Widget>[
                Center(child: Text("Something Went Wrong")),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        stackIndex = 0;
                      });
                    },
                    child: Text("Try again"))
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildNameContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(6)),
      child: TextFormField(
        controller: _nameController,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: "John Doe",
          labelText: "Name",
        ),
        validator: (v) {
          if (v.isEmpty) {
            return "Name is required";
          }
          if (v.length < 3) {
            return "Name should be 3 or more letters";
          }

          return null;
        },
      ),
    );
  }

  Container buildPhoneContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(6)),
      child: TextFormField(
        controller: _phoneController,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: "10 digits",
          labelText: "Mobile",
        ),
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
    );
  }

  Container buildEmailContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(6)),
      child: TextFormField(
        controller: _emailController,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: "some@example.com",
          labelText: "Email",
        ),
        validator: (v) {
          if (v.isEmpty) {
            return 'Field is required';
          }

          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(v);
          if (!emailValid) {
            return "Enter valid email";
          }

          return null;
        },
      ),
    );
  }

  Container buildQueryContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(6)),
      child: TextFormField(
        controller: _feedbackController,
        minLines: 12,
        maxLines: 12,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: "Type your feedback here....",
        ),
        validator: (v) {
          if (v.isEmpty) {
            return "Field is required";
          }
          return null;
        },
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
