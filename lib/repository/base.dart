import 'package:nityaassociation/repository/repo.dart';

abstract class BaseBloc {
  final repository = Repository();

  void dispose() {}
}
