import 'package:flutter/material.dart';
import 'package:projet_final/Forgot_password/Regain_password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/auth/auth_controller.dart';
import 'Forgot_password.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'New_password.dart';


class VerificationCode extends ConsumerStatefulWidget {
  final String contact;

  VerificationCode({super.key, required this.contact});

  @override
  ConsumerState<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends ConsumerState<VerificationCode> {
  String _otpCode = "";

 

  @override
  Widget build(BuildContext context) {


      ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
  next.when(
    data: (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NewPassword()),
      );
    },
    loading: () {},
    error: (err, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code incorrect ou expiré')),
      );
    },
  );
});

    final option = ref.watch(selectedOption);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegainPassword()),
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: 327,
                height: 115,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Verification Code',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      option == "email"
                          ? 'Please enter the code we just sent to your email'
                          : 'Please enter the code we just sent to your phone number',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.contact,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF512DA8),
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  _otpCode = code;
                },
                onSubmit: (String verificationCode) {
                  _otpCode = verificationCode;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "If you didn't receive a code?",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () async {
                      final AuthController =
                          ref.read(authControllerProvider.notifier);
                      if (option == "email") {
                        await AuthController.sendOtpEmail(widget.contact);
                      } else {
                        await AuthController.sendOtpPhone(widget.contact);
                      }
                    },
                    child: Text(
                      'Resend',
                      style: TextStyle(color: Color(0xFF54408C)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final auth = ref.read(authControllerProvider.notifier);
                  await auth.verifyOtp(
                    contact: widget.contact,
                    code: _otpCode,
                    option: option,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF54408C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: Container(
                  width: 327,
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
