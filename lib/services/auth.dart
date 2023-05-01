import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/firebaseuser.dart';
import '../models/loginuser.dart';
import '../models/usermodel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('users');
  static Reference refStorage = FirebaseStorage.instance.ref();


  String imageUrl = '';

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _firebaseUser(user);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signInEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }

  Future singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final googleSingInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSingInAuthentication.accessToken,
            idToken: googleSingInAuthentication.idToken);

        UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);
        User? user = userCredential.user;
        return _firebaseUser(user);
      }
    } catch (e) {
      // print("ss");
      print(e);
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future registerEmailPassword(
      LoginUser _login,
      String fullName,
      String mobileNumber,
      String email,
      String age,
      String assignedTo,
      String imgurl,
      bool isAssigned) async {
    try {
      //Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());

      /*final User? userr = _auth.currentUser;
      final _uid = userr?.uid;*/
      /*user?.updatePhotoURL(imageUrl);
      user?.reload();*/

      //Add user details
      //addUserDetails(fullName, mobileNumber, email, age);
      updateUserData(fullName, mobileNumber, email, age, 'Patient',
        assignedTo, false,imgurl);

      //Return user
      User? user = userCredential.user;
      
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future  signOutWithGoogle() async {
  // Sign out with firebase
  // await _auth.signOut();
  // Sign out with google
  await _googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();

}

  getImage(String imageName) {
    refStorage.child(_auth.currentUser!.uid).child(imageName);
  }

  getImages() async {
    var collection = FirebaseFirestore.instance.collection('history');
    var docSnapshot =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (docSnapshot.exists) {
      Map<String,dynamic>? data = docSnapshot.data();
      var values = data?['images'];
      return values;
    }
  }

  updateDiagnosis(String label) {
    var diagnosis = [label];
    FirebaseFirestore.instance
        .collection("history")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'diagnosis': FieldValue.arrayUnion(diagnosis),
    });
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    print(filePath);
    File file = File(filePath);
      

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child(_auth.currentUser!.uid);
    Reference referenceImageToUpload = referenceDirImage.child(fileName);
    try {
      await referenceImageToUpload.putFile(file);
      imageUrl = await referenceImageToUpload.getDownloadURL();
      final Reference storage =
          FirebaseStorage.instance.ref().child("${_auth.currentUser!.uid}.jpg");
      final UploadTask task = storage.putFile(file);

      task.then((value) async {
        String url = (await storage.getDownloadURL()).toString();
        var image = [url];
        //var diagnosis = ['Tumor'];
        FirebaseFirestore.instance
            .collection("history")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'id': _auth.currentUser!.uid,
          'email': _auth.currentUser!.email,
          'images':FieldValue.arrayUnion(image),
          //'diagnosis': FieldValue.arrayUnion(diagnosis),
          'time': DateTime.now(),
        });
      });
    } on firebase_core.FirebaseException catch (e) {
e.message;    }
  }

  Future<void> uploadImageFromCamera(String filePath, String fileName) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child(_auth.currentUser!.uid);
    Reference referenceImageToUpload = referenceDirImage.child(fileName);
    try{
      await referenceImageToUpload.putFile(File(filePath));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    }catch(error){
      print(error);
    }
  }

  Future updateUserData(String fullName, String mobileNumber, String email,
      String age, String role, String selectedDoctor, bool isAssigned,String imgurl)
      async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.role = role;
    userModel.name = fullName;
    userModel.number = mobileNumber;
    userModel.age = age;
    userModel.isAssigned = false;
    userModel.imgurl = imgurl;
    userModel.assignedTo = selectedDoctor;

      await collection.doc(user.uid).set(userModel.toMap());

        
        

    // Future updateUserData(String? uid, String fullName, String mobileNumber,
    //     String email, String age) async {
    //   collection
    //       .where(uid!, isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //       .limit(1)
    //       .get()
    //       .then((QuerySnapshot querySnapshot) {
    //     if (querySnapshot.docs.isEmpty) {
    //       collection.add({
    //         'uid': uid,
    //         'fullName': fullName,
    //         'mobileNumber': mobileNumber,
    //         'email': email,
    //         'age': age,
    //       });
    //     }
    //   }).catchError((error) {});
    }
  }
