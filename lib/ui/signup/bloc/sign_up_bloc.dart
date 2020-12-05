import 'package:nityaassociation/model/error_model.dart';
import 'package:nityaassociation/model/sign_model.dart';
import 'package:nityaassociation/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc {
  final _signUpStream = PublishSubject<SignResponse>();
  final _loadingStream = PublishSubject<bool>();
  final _errorStream = PublishSubject<Error>();

  Stream<SignResponse> get signUpStream => _signUpStream.stream;

  Stream<bool> get loadingStream => _loadingStream.stream;

  Stream<Error> get errorStream => _errorStream.stream;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signUpStream?.close();
    _loadingStream?.close();
    _errorStream?.close();
  }

  void signUp(String name, String phone) async {
    print("calling");
    if (isLoading) return;
    isLoading = true;
    _loadingStream.sink.add(true);
    SignResponse r = await repository.signUp(name, phone);
    isLoading = false;
    _loadingStream.sink.add(isLoading);
    _signUpStream.sink.add(r);

//       .then((value) {
//      print(value);
//      isLoading = false;
//      _loadingStream.sink.add(isLoading);
//      _signUpStream.sink.add(User.fromJson(value['user']));
//    }).catchError((error) {
//      isLoading = false;
//      _loadingStream.sink.add(isLoading);
//      _errorStream.add(Error.fromJson(error));
//    });
  }
}
