import 'package:firebase/screens/authenticate/handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardModel {
  final String? image;
  final String? title;
  final String? body;
  BoardModel({this.image,this.title,this.body});
   
}

class onBoadring extends StatefulWidget {


  @override
  State<onBoadring> createState() => _onBoadringState();
}

class _onBoadringState extends State<onBoadring> {
  @override
  var boardController = PageController();
  bool flag = false;
  List <BoardModel> model = 
  [
    BoardModel(image: "assets/images/128.jpg",body: "",title: ""),
    BoardModel(image: "assets/images/4990224.jpg",body: "",title:""),
    BoardModel(image: "assets/images/7900653.jpg",body: "",title:""),

  ];
  bool showSignin = true;


  // void toggleView(){
  //   setState(() {
  //     showSignin = !showSignin;
  //   });
  // }
  Widget build(BuildContext context) {
    return Scaffold
    ( 
      
      body :Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
              controller: boardController
              ,
              onPageChanged: (value) => {
                if(value == model.length)
                {
                  flag = false

                }
                else
                {
                  flag = true 
               }
              },  
              itemBuilder: (context,index)=>buildBoardingItem(model[index]),
              itemCount: model.length,),
            )
          ,
       const   SizedBox(height: 40,)
        ,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
             SmoothPageIndicator(controller:boardController,count: model.length,effect:const ExpandingDotsEffect(
              activeDotColor:Colors.black ,
              dotColor: Colors.grey,
              dotHeight: 10,
              dotWidth: 10,
              expansionFactor: 4
             ) ,), 
             Spacer(flex: 3,),
            Expanded(
              child: 
                
                FloatingActionButton(backgroundColor: Colors.black,onPressed: () {
                  
                  if(flag ==true )
                  {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Handler()),
                          (Route<dynamic> route) => false,
                    );                  }
                  else {
                     boardController.nextPage(
                  duration:const Duration(
                    milliseconds: 750
                  ) , 
                  curve: Curves.fastLinearToSlowEaseIn); 
                  }
                  
                   },

                  child: const Icon(Icons.arrow_forward,
                  color: Colors.white,),
                ) ,),
              
            
            ],
          )
          ],
        ),
      )
      
    );
  }
Widget buildBoardingItem(BoardModel model)=>
Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> 
        
        [
          
          Expanded(
            child: Image( 
              image: AssetImage('${model.image}'),
            ),
          )
        ,
        SizedBox(height: 10,),
        Text('${model.title}',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),
        ),
        SizedBox(height: 15,),
        Text('${model.body}',
        style: TextStyle(fontWeight: FontWeight.bold),)

        ],
      );
}

