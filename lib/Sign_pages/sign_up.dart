import 'package:flutter/material.dart';
import 'package:projet_final/Sign_pages/congrats_page.dart';
import 'package:projet_final/Sign_pages/sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projet_final/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/models/models.dart';
import 'package:projet_final/models/providers.dart';


class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
   ConsumerState<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends  ConsumerState<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool viewPassword = false ; 
  final supabase=Supabase.instance.client ; 
  

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
                onPressed: (){}),
                 const SizedBox(height: 16),
    
                   Text('Sign Up ' , style: TextStyle(
                                      color: Colors.black , fontSize: 24 , fontWeight:FontWeight.w700),) , 
                                       const SizedBox(height: 8),
                               Text('Create account and choose favorite menu ' , style: TextStyle(color:Colors.grey , fontSize: 14),),
                
               const SizedBox(height: 24),    
               
                
        //Name
                    const Text('Name', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your Name',
                   hintStyle: TextStyle( color: Colors.grey),
                    filled: true,
                 fillColor: Colors.grey.shade100,
                   enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                ),
              ),
              const SizedBox(height: 16),
                  
                 // Email
              const Text('Email', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
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
              const SizedBox(height: 24),
                      
                      
                  ElevatedButton(
                    onPressed:() async{
                      
                      try{
                           final email=emailController.text ; 
                    final password=passwordController.text ;
                    final name=nameController.text ;
                 if (name.isEmpty || email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all the fields")),
    );return; 
                 }

                  await  ref.read(authControllerProvider.notifier).signUp(email, password);
                 
                     final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("User ID not found");

        final newUser = user(id: userId, name: name, phone: '' , avatar:'');
      await ref.read(usersProvider.notifier).adduser(newUser);
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CongratsPage()),
                      );

                      }catch(e){
                         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors de l'inscription : $e")),);
                      }
                 


                    }, 
                     style:ElevatedButton.styleFrom(
                      backgroundColor:Color(0xFF54408C),
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48)),),
                    child: Container(
                      width: 327,
                      alignment: Alignment.center,
                      child: Text('Register' , style: TextStyle(color: Colors.white , fontSize: 16)) ,
                       
                    ) ,
                    ),
                     const SizedBox(height: 16),
                  
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have an account? ', style: TextStyle(color: Colors.grey , fontSize: 14),),
                  TextButton(
                    onPressed: () {
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          color: Color(0xFF54408C),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              Spacer(),

            
              Center(
                  child:Column(
                    children: [
                        Text('By clicking register, you agree to our' , style: TextStyle(color: Colors.grey , fontSize: 14),),
                      TextButton(
                        onPressed: () {
                  
                        },
                        child: const Text(
                          'Terms and Data Policy',
                          style: TextStyle(
                              color: Color(0xFF54408C),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


