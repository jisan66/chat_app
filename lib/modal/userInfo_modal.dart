class UserInfoModal {
  String? name;
  String? username;
  String? firstLetter;
  String? email;
  String? password;
  String? photo;
  String? id;

  UserInfoModal(
      {this.name,
        this.username,
        this.firstLetter,
        this.email,
        this.password,
        this.photo,
        this.id});

  UserInfoModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    firstLetter = json['first_letter'];
    email = json['email'];
    password = json['password'];
    photo = json['photo'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['first_letter'] = firstLetter;
    data['email'] = email;
    data['password'] = password;
    data['photo'] = photo;
    data['id'] = id;
    return data;
  }
}
