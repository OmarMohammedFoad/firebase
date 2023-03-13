class UserModel
{
      String? email;
     String? uid;
     String?role;
     String?name;
     String?number;
     String?age;
     bool?isAssigned;
     String? isSelected;

  UserModel({this.age,this.email,this.isAssigned,this.name,this.number,this.role,this.uid});
  Map<String,dynamic> toMap() =>{
    "email":email,
    "fullname":name,
    "uid":uid,
    "role":role,
    "age":age,
    "isAssigned":isAssigned,
    "isSelected":isSelected
      };
}
