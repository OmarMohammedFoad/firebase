import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HistoryScreen();
  }
}

class _HistoryScreen extends State<HistoryScreen> {
  final AuthService _auth = new AuthService();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('history').doc(userId).get(),
              builder: (_, snapshot) {
                if (snapshot.hasError) return Text ('Error = ${snapshot.error}');

                if (snapshot.hasData) {
                  var data = snapshot.data!.data();
                  var images = data!['images']; // <-- Your value
                  print('images $images');
                  //return Text('Value = $value');
                  return CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 1.0,
                      initialPage: 0,
                    ),
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return Container(
                        child: Image.network(images[index]),
                        width: double.infinity,
                      );
                  },

                  /*
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(images[index]),
                            //child: Text(snapshot.data!.items[index].name),
                          );
                        }),
*/
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            )

/*
            FutureBuilder(
                future: FirebaseFirestore.instance.collection('history')
                .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(snapshot.data!.items[index].name),
                              //child: Text(snapshot.data!.items[index].name),
                            );
                          }),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                }),
*/

/*
            FutureBuilder(
                future: _auth.downloadURL('image_picker3015579039885344615.jpg'),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        width: 300,
                        height: 250,
                        child: Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                }),
*/
          ],
        ),
      ),
    );
  }
}