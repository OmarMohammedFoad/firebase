import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String? uid;
  String? role;
  String? name;
  String? number;
  //String? age;
  Timestamp? timestamp;
  String? weight;
  String? height;
  String? bloodGroup;
  String? gender;
  String? imgurl;
  bool? isAssigned;
  String? assignedTo;

  UserModel(
      {this.timestamp,
        //this.age,
      this.weight,
      this.height,
      this.bloodGroup,
      this.email,
        this.gender,
      this.isAssigned,
      this.imgurl,
      this.name,
      this.number,
      this.role,
      this.uid});

  Map<String, dynamic> toMap() =>
      {
        "email": email,
        "name": name,
        "uid": uid,
        "role": role,
        //"age": age,
        "dateOfBirth": timestamp,
        "weight": weight,
        "height": height,
        "bloodGroup": bloodGroup,
        "gender": gender,
        "imgurl": imgurl,
        "isAssigned": isAssigned,
        "assignedTo": assignedTo,
        "number": number,
      };
}
