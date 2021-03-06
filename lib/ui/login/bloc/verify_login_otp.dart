import 'package:nityaassociation/model/error_model.dart';
import 'package:nityaassociation/model/user.dart';
import 'package:nityaassociation/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class VerifyLoadingOtp extends BaseBloc {
  final _otpVerifyStream = PublishSubject<dynamic>();
  final _loadingStream = PublishSubject<bool>();
  final _errorStream = PublishSubject<Error>();

  Stream<dynamic> get signInStream => _otpVerifyStream.stream;

  Stream<bool> get loadingStream => _loadingStream.stream;

  Stream<Error> get errorStream => _errorStream.stream;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _otpVerifyStream?.close();
    _loadingStream?.close();
    _errorStream?.close();
  }

  void verifyLoginOtp(String otp, String phone) async {
    if (isLoading) return;
    isLoading = true;
    _loadingStream.sink.add(true);

    await repository.verifyLoginOtp(otp, phone).then((value) {
      print(value);
      isLoading = false;
      _loadingStream.sink.add(isLoading);
      _otpVerifyStream.sink.add(User.fromJson(value['user']));
    }).catchError((error) {
      isLoading = false;
      _loadingStream.sink.add(isLoading);
      _errorStream.sink.add(Error.fromJson(error));
    });
  }
}
