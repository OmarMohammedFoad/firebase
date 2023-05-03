class UserModel {
  String? email;
  String? uid;
  String? role;
  String? name;
  String? number;
  String? age;
<<<<<<< Updated upstream
  String? imgurl;
  bool? isAssigned;
=======
  Future<dynamic>? isAssigned;
>>>>>>> Stashed changes
  String? assignedTo;

  UserModel(
      {this.age,
      this.email,
      this.isAssigned,
      this.imgurl,
      this.name,
      this.number,
      this.role,
      this.uid});

  Map<String, dynamic> toMap() => {
        "email": email,
        "name": name,
        "uid": uid,
        "role": role,
        "age": age,
        "imgurl": imgurl,
        "isAssigned": isAssigned,
        "assignedTo": assignedTo,
        "number": number,
      };
}
