import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/historyList.dart';
import 'package:firebase/screens/profile_screen.dart';
import 'package:firebase/screens/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'history_screen.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Kidnopathy'),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("My History"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      //print("My account menu is selected.");
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => HistoryListScreen())
                      );
                    }
                  },
                )
              ],
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Theme.of(context).primaryColor,
              bottom: TabBar(
                tabs: <Tab>[
                  Tab(
                    text: 'Home',
                    icon: FaIcon(FontAwesomeIcons.home),
                  ),
                  //Tab(text: 'History', icon: FaIcon(FontAwesomeIcons.history)),
                  Tab(text: 'Profile', icon: FaIcon(FontAwesomeIcons.user)),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            //KidneyDiseaseDetection(),
            UploadImageScreen(),
            //HistoryScreen(),
            //HistoryListScreen(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}