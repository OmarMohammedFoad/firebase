import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:tflite/tflite.dart';
import 'dart:convert';

import 'historyScreen.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? pickedImage;
  bool isImageLoaded = false;
  bool isClassified = false;
  String?body = "";


  late List _result;
  String _name = "";
  String _confidence = "";

  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  // loadModel() async {
  //   var result = await Tflite.loadModel(
  //     labels: "assets/labels.txt",
  //     model: "assets/model.tflite",
  //   );
  //
  //   print('Results after loading the model: $result');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadModel();
    imgRef = FirebaseFirestore.instance.collection('temp');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Tflite.close();
  }

  // Future imageClassification(File image) async {
  //   // final List? recognitions = await Tflite.runModelOnImage(
  //   //   path: image.path,
  //   //   numResults: 4,
  //   //   threshold: 0.05,
  //   //   imageMean: 127.5,
  //   //   imageStd: 127.5,
  //   // );
  //   setState(() {
  //     _result = recognitions!;
  //     print('results are $_result');
  //     _name = _result[0]['label'];
  //     _confidence = _result != null
  //         ? (_result[0]['confidence'] * 100.0).toString().substring(0, 3) + '%'
  //         : "";
  //     isClassified = true;
  //     print('Diagnosis $_name and confidence $_confidence');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            isImageLoaded
                ? Center(
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(pickedImage!.path)),
                        fit: BoxFit.contain)),
              ),
            )
                : Container(width: 300, height: 300, color: Colors.grey[300]!),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shadowColor: Colors.grey[400],
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.black,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shadowColor: Colors.grey[400],
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.black,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shadowColor: Colors.grey[400],
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onPressed: () {
                        uploadFile().whenComplete(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryList())));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.upload_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
                            Text(
                              "Upload Image",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            isClassified
                ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
              'Diagnosis: $body',
              style: const TextStyle(color:Colors.green, fontSize: 20),
            ),
                )
                : Container()
          ],
        ),
      ),
    );
  }

  Future  uploadImage (pickedImage) async
  {
    if(pickedImage == null) return "";

    String base64 =  base64Encode(pickedImage!.readAsBytesSync());
    String imagename = pickedImage!.path.split("/").last;
    String data = base64;
    Map<String, String> requestHeaders ={'Content-type': 'application/json',
      'Accept': 'application/json',};
    var  response = await http.put(Uri.parse("https://83d5-197-162-180-97.ngrok-free.app/api"),body: data,headers:requestHeaders );

    print(response.body);
    setState(() {
      isClassified = true;
      body = response.body;
    });
  }












  getImage(ImageSource source) async {
    var tempStore = await ImagePicker().pickImage(source: source);
    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
    });
    uploadImage(pickedImage);
    if (tempStore == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        pickedImage = response.file!.path as File;
      });
    } else {
      print(response.file);
    }
  }

  String assignedTo = '';
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> uploadFile() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        assignedTo = data['assignedTo'];
      }
    } catch (e) {
      print('Error getting assignedTo value: $e');
    }

    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(pickedImage!.path);
    await ref?.putFile(pickedImage!).whenComplete(() async {
      await ref?.getDownloadURL().then((value) {
        imgRef?.add({
          'url': value,
          'id': FirebaseAuth.instance.currentUser!.uid,
          'email': FirebaseAuth.instance.currentUser!.email,
          'diagnosis': body!.substring(0,7),
          'time': DateTime.now(),
          'assignedTo': assignedTo,
        });
      });
    });
  }
}
