import 'package:flutter/material.dart';
import 'package:projet_final/Sign_pages/sign_in.dart';
import 'Regain_password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedOption = 
StateProvider<String>((ref) => '');

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
  
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child:Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:IconButton(
                  onPressed: (){
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                        );
                  },
                   icon: Icon(Icons.arrow_back)),
              ), 
              SizedBox(height:12),
          
              SizedBox(
                width:327,
                height:88,
                child: Column(
                  children: [
                    Align(
                      alignment:Alignment.centerLeft,
                      child: Text('Forgot Password' , style: TextStyle(color:Colors.black ,fontSize: 24 , fontWeight: FontWeight.w700),
                                       ),
                    ),
                    SizedBox(height:8),
                     Text('Select which contact details should we use to reset your password',
              style: TextStyle(color: Colors.grey.shade500,fontSize: 16),) ,
          
                  ],
                )
                ),
                SizedBox(height:20) , 
          
                
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      ref.read(selectedOption.notifier).state="email";
                    });
                  },
                  child: Container(
                    width:158 ,
                    height: 151,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                       color: Colors.grey.shade50,
                       border: Border.all(
                        color:
                        ref.watch(selectedOption)=="email"?
                        Color(0xFF54408C) :Colors.transparent ,
                       ),
                    ),
                   child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                         
                          padding: EdgeInsets.only(left:20),
                           child:Image.asset('assets/Forgot_password_icons/email_icon.png'),) 
                      ),
                    
                      Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email' , style: TextStyle(color: Colors.black,fontSize: 14, fontWeight: FontWeight.w500),),
                          Text('Send to your email' , style: TextStyle(color: Colors.grey.shade500,fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ), 
                    ],
                   )               
                  ),
                ),
                
          
                InkWell(
                  onTap: () {
                    setState(() {
                       ref.read(selectedOption.notifier).state="phone";
                    });
                  },
                  child: Container(
                    width:158 ,
                    height: 151,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                       color: Colors.grey.shade50,
                          border: Border.all(
                        color:
                        ref.watch(selectedOption)=="phone"?
                        Color(0xFF54408C) :Colors.transparent ,
                       )
                    ),
                  
                   child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  
                        Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                        
                          padding: EdgeInsets.only(left:20),
                            child:Image.asset('assets/Forgot_password_icons/phone_icon.png'),) 
                      ),
                      
                      Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone Number' , style: TextStyle(color: Colors.black,fontSize: 14, fontWeight: FontWeight.w500),),
                          Text('Send to your phone' , style: TextStyle(color: Colors.grey.shade500,fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ), 
                    ],
                   )               
                  ),
                ),
          
              ],
          
             ),
             SizedBox(height:50),
             
           ElevatedButton(
                      onPressed: (){
                        if (ref.read(selectedOption)!=''){
                             Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegainPassword()),
                        );   
                          
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:Text('please select an option')));
                        }
                     
              
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
                        child: Text( 'Continue'  , style: TextStyle(color: Colors.white , fontSize: 16),
                        )
                        ),
                      
                      ),
          ],
          ),
        )
        )
    );
  }
}