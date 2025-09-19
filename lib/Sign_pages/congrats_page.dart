import 'package:flutter/material.dart';
import 'package:projet_final/Home/home_page.dart';


class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 300),
        child: Center(
          child:Column(children: [
            SizedBox(
              width:160, 
              height:91,
              child: Image.asset('assets/Sign/Congrats.png'),
            ),
            SizedBox(height: 24),
            SizedBox(
              width:327,
             
              child: Column(
                children: [
                  Text('Congratulations' , style:TextStyle(
                                  fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    
                              ),
                                 textAlign: TextAlign.center,
                               ),
                             SizedBox(height: 10),
                             
                            Text('your account is complete, please enjoy the best menu from us.' , 
                             style:TextStyle(
                                  fontSize: 16,
                                    color: Colors.grey.shade600,
                                    decoration: TextDecoration.none,
                                    
                              ),
                                textAlign: TextAlign.center,
                              ),
                ],
              ),
            ),
            SizedBox(height: 24),
        
            ElevatedButton(
                    onPressed: (){
                       Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  HomePage()),
                      );
            
                    }, 
                    
                      style:ElevatedButton.styleFrom(
                              backgroundColor:Color(0xFF54408C),
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48)),),
                                child: 
                    Container(
                      width: 327,
                       height: 56,
                      alignment: Alignment.center ,
                      child: Text( 'Get Started'  , style: TextStyle(color: Colors.white , fontSize: 16),
                      )
                      ),
                    
                    ),
           
        
        
          ],) ,),
      )
    );
  }
}