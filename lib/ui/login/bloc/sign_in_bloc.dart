import 'package:nityaassociation/model/login_model.dart';
import 'package:nityaassociation/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc {
  final _signInStream = PublishSubject<LoginResponse>();
  final _loadingStream = PublishSubject<bool>();
  final _errorStream = PublishSubject<String>();

  Stream<LoginResponse> get signInStream => _signInStream.stream;

  Stream<bool> get loadingStream => _loadingStream.stream;

  Stream<String> get errorStream => _errorStream.stream;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signInStream?.close();
    _loadingStream?.close();
    _errorStream?.close();
  }

  void signIn(String phone) async {
    print("calling");
    if (isLoading) return;
    isLoading = true;
    _loadingStream.sink.add(true);

    LoginResponse r = await repository.login(phone);
    isLoading = false;
    _loadingStream.sink.add(isLoading);
    _signInStream.sink.add(r);
//        .then((value) {
//      print(value);
//      isLoading = false;
//      _loadingStream.sink.add(isLoading);
//      _signInStream.sink.add(value.user);
//    }).catchError((error) {
//      isLoading = false;
//      _loadingStream.sink.add(isLoading);
//      _errorStream.add(error);
//    });
  }
}
