class Post{
  int _userId;
  int _id;
  String _title;
  String _body;

  Post (this._userId, this._id, this._title, this._body);

  int get userId => _userId;
  set userId(int userId)=> _userId = userId;

  int get id => _id;
  set id(int id)=> _id = id;

  String get title => _title;
  set title(String title)=> _title = title;

  String get body => _body;
  set body(String body)=> _body = body;
}