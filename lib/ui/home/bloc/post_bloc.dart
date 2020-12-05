import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends BaseBloc {
  static final PostBloc _postBloc = PostBloc._internal();

  factory PostBloc() {
    return _postBloc;
  }

  PostBloc._internal();

  final _postStream = BehaviorSubject<PostResponse>();

  Stream<PostResponse> get posts => _postStream.stream;

  fetchPosts(String accessToken) async {
    PostResponse posts = await repository.fetchPosts(accessToken);
    _postStream.sink.add(posts);
  }

  dispose() {
    _postStream.close();
  }
}

final postBloc = PostBloc();
