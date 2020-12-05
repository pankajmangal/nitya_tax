import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nityaassociation/ui/common/notification_app_bar.dart';
import 'package:nityaassociation/ui/settings/about_us.dart';
import 'package:nityaassociation/ui/settings/terms_n_conditions.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/prefs_helper.dart';

class Settings extends StatelessWidget {
  final List _settings = ['About Us', 'Terms & Conditions', "Logout"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: NotificationAppBar('Settings'),
          preferredSize: Size.fromHeight(56)),
      body: ListView.separated(
        itemCount: _settings.length,
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () {
              switch (index) {
                case 0:
                  //open about us
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AboutUs()));
                  break;
                case 1:
                  //open terms
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TermsAndConditions()));
                  break;
                case 2:
                  _sureLogout(context);
              }
            },
            title: Text(_settings[index]),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Future<bool> _sureLogout(BuildContext context) {
    return showDialog(
          context: context,
          child: AlertDialog(
            actionsPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            title: Text('Logout?'),
            content: Text(
              "This will log you out from this device.",
              style: TextStyle(color: Colors.black54),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              FlatButton(
                onPressed: () {
                  PrefsHelper.deleteUser();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  'OKAY',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
