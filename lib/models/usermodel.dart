class UserModel {
  String? email;
  String? uid;
  String? role;
  String? name;
  String? number;
  String? age;
  bool? isAssigned;
  String? assignedTo;

  UserModel(
      {this.age,
      this.email,
      this.isAssigned,
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
        "isAssigned": isAssigned,
        "assignedTo": assignedTo,
        "number": number,
      };
}
