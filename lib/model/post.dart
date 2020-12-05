class Post {
  int id;
  int postType;
  String title;
  String description;
  int category;
  List<String> bookmarkedBy;
  String url;
  String timestamp;

  Post(
      {this.id,
        this.postType,
        this.title,
        this.description,
        this.category,
        this.bookmarkedBy,
        this.url,
        this.timestamp});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    title = json['title'];
    description = json['description'];
    category = json['category'];
    bookmarkedBy = json['bookmarked_by'].cast<String>();
    url = json['url'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['category'] = this.category;
    data['bookmarked_by'] = this.bookmarkedBy;
    data['url'] = this.url;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class PostResponse {
  final List<Post> posts;
  final String error;

  PostResponse(this.posts, this.error);

  PostResponse.fromJson(Map<String, dynamic> json)
      : posts = json.isNotEmpty
            ? (json["post"] as List).map((i) => new Post.fromJson(i)).toList()
            : List(),
        error = "";

  PostResponse.withError(String errorValue)
      : posts = List(),
        error = errorValue;
}
