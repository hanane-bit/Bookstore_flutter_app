import 'package:flutter/material.dart';
import 'package:projet_final/Home/home_page.dart';
import 'package:projet_final/Sign_pages/spash_screen.dart';
import 'package:projet_final/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/Sign_pages/sign_up.dart';
import 'package:projet_final/Forgot_password/Forgot_password.dart';


class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}
class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool viewPassword = false ; 

@override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(24.0),
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //1
               IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const spashScreen()),
                      );
                }),
                 const SizedBox(height: 16),
    
                   Text('Welcome Back 👋 ' , style: TextStyle(
                                      color: Colors.black , fontSize: 24 , fontWeight:FontWeight.w700),) , 
                                       const SizedBox(height: 8),
                               Text('Sign to your account' , style: TextStyle(color:Colors.grey , fontSize: 14),),
                
               const SizedBox(height: 24),    
               
                 
                 // Email
              const Text('Email', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                 keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                 filled: true,
                 fillColor: Colors.grey.shade100,
                enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  hintText: 'Your Email',
                   hintStyle: TextStyle( color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
                  
                  //13
                   // Password
              const Text('Password', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: viewPassword,
                decoration: InputDecoration(
                    filled: true,
                 fillColor: Colors.grey.shade100,
                  hintText: 'Your Password',
                   hintStyle: TextStyle( color: Colors.grey),
                  enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),),
                  suffixIcon: IconButton(
                    icon: Icon(
                      viewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                      viewPassword = !viewPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: (){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPassword()),
                      );

                },
                child: Text('Forgot Password ?' , style: TextStyle(color: Color(0xFF54408C) , fontWeight: FontWeight.bold , fontSize: 14),)),
              const SizedBox(height: 24),
                      
                      
                  ElevatedButton(
                    onPressed:()async {
                     final email=emailController.text ;
                      final password=passwordController.text;
                   final result =  await ref.read(authControllerProvider.notifier).signIn(email, password);
                      if (result == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }

                    }, 
                     style:ElevatedButton.styleFrom(
                      backgroundColor:Color(0xFF54408C),
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48)),),
                    child: Container(
                      width: 327,
                      alignment: Alignment.center,
                      child: Text('Log In ' , style: TextStyle(color: Colors.white , fontSize: 16)) ,
                       
                    ) ,
                    
                    ),
                     const SizedBox(height: 16),
                  
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey , fontSize: 14),),
                  TextButton(
                    onPressed: () {
                     Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Color(0xFF54408C),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 24,),
            Center(child: Text('Or with' , style: TextStyle(color: Colors.grey, fontSize: 14),),),
             SizedBox(height: 20,),
           
            
               
                  TextButton(
                    onPressed: (){},
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 65),
                       child: Row(children: [
                       Image.asset( 'assets/Sign/google.png'),
                       SizedBox(width:15),
                        Text('Sign in with Google' , style: TextStyle(fontSize: 14),),
                       ],
                       ),
                     ),
                       
                  ),
                   TextButton(
                      onPressed: (){},
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 65),
                         child: Row(children: [
                         Image.asset( 'assets/Sign/apple.png'),
                         SizedBox(width:15),
                          Text('Sign in with Apple' , style: TextStyle(fontSize: 14),),
                         ],
                         ),
                       ),
                       ),
                  
              ], 
          ),
        ),
      ),
    );
  }
}