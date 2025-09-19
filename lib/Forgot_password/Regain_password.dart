import 'package:flutter/material.dart';
import 'package:projet_final/Forgot_password/Forgot_password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/Forgot_password/Verification_code.dart';
import 'package:projet_final/auth/auth_controller.dart';



class RegainPassword extends ConsumerStatefulWidget {
  RegainPassword({super.key});

  @override
  ConsumerState<RegainPassword> createState() => _RegainPasswordState();
}

class _RegainPasswordState extends ConsumerState<RegainPassword> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final option = ref.watch(selectedOption);

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
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        option == "email"
                            ? 'Please enter your email, we will send verification code to your email.'
                            : 'Please enter your phone number, we will send a verification code to your phone number.',
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
              Center(
                child: Container(
                  width: 327,
                  height: 76,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option == "email" ? "Email" : 'Phone Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                     
                      TextField(
                        controller: controller,
                      
                         keyboardType: option == 'phone' 
                    ? TextInputType.phone 
                   : TextInputType.emailAddress,
                        decoration: InputDecoration(
                           prefixText: option == 'phone' ? '+213 ' : null,
                          prefixIcon: option=='phone'?
                          
                          Padding(padding: EdgeInsets.all(5), 
                          child:Image.asset('assets/Forgot_password_icons/Phone-Outline.png'),
                          ):null ,
                          
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 327,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final AuthController=ref.read(authControllerProvider.notifier);
                      if (option=="email"){
                        await AuthController.sendOtpEmail(controller.text);
                      }else{
                        await AuthController.sendOtpPhone(controller.text);
                      }
                       Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  VerificationCode( contact:controller.text)),
                      );
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
