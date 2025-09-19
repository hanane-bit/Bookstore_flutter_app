import 'package:flutter/material.dart';
import 'package:projet_final/Forgot_password/Forgot_password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/Sign_pages/sign_in.dart';

import 'package:projet_final/auth/auth_controller.dart';



class NewPassword extends ConsumerStatefulWidget {
  NewPassword({super.key});

  @override
  ConsumerState<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends ConsumerState<NewPassword> {
  TextEditingController password = TextEditingController();
    TextEditingController confirm_password = TextEditingController();
      bool viewPassword = false ; 

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()),
                  );
                },
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(height: 12),
              Center(
                child: Container(
                  width: 327,
                  height:   115,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your new password, so you can login to your account.',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
               const Text('New Password', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: password,
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
              
              SizedBox(height: 20),

               const Text(' Confirm Password', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: confirm_password,
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

               SizedBox(height: 24),
              Center(
                child: Container(
                  width: 327,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async  {
                      if (password.text != confirm_password.text) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Passwords do not match")),
  );
  return; 
}else {
      await ref.read(authControllerProvider.notifier).updatePassword(password.text);
       ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Password updated successfully")),
  );

   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                      );

      }
                     
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF54408C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
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
