import 'package:flutter/material.dart';
import 'onboarding_pages.dart';



class spashScreen extends StatefulWidget {
  const spashScreen({super.key});

  @override
  State<spashScreen> createState() => _spashScreenState();
}

class _spashScreenState extends State<spashScreen> {

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds:2), 
    (){
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  OnboardingPage()),
        );
    }
    
    
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF54408C) ,
      body:SafeArea(child: Center(
        child:Container(
          width: 158,
          height: 44,
          child:
            Padding(
           padding: const EdgeInsets.only(right:12.62 , left:12.62),
           child: Row(mainAxisAlignment: MainAxisAlignment.center ,
           children: [
             Image.asset('assets/Sign/Vector.png' , height: 37.85,width:37.94),
             SizedBox(width:12),

             Image.asset('assets/Sign/Chapter.png' , width: 82,height:44),

           ],

           ),
           
           )

        )
       
       
      ))
    );
  }
}