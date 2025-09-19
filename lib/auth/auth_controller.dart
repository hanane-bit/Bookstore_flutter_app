import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthController extends AsyncNotifier<void>{
  @override
  FutureOr<void> build(){ 
  }

//SIGN UP
  
  Future<void> signUp(String email , String password ) async {

    state= const AsyncLoading();
    final supabase=ref.read(supabaseClientProvider) ;
    state= await AsyncValue.guard(()async{
      final res= await supabase.auth.signUp(
    email: email,
    password: password
  );
  if (res.user!=null){
    await supabase.auth.signInWithPassword(
      email:email,
      password: password);
  }

    });
}





//SIGN IN
  Future<String> signIn(String email, String password) async {
  state = const AsyncLoading();
  final supabase = ref.read(supabaseClientProvider);

  try {
    final res = await supabase.auth.signInWithPassword(email: email, password: password);
    if (res.user != null) {
      return "success";
    } else {
      return "Incorrect email or password";
    }
  } catch (e) {
    return e.toString();
  }
}



//SIGN OUT 

 Future<void> signOut() async {
    state = const AsyncLoading();
    final supabase = ref.read(supabaseClientProvider);

    state = await AsyncValue.guard(() async {
      await supabase.auth.signOut();
    });
  }


  //SEND OTP TO EMAIL 
Future<void> sendOtpEmail(String email) async{
   state = const AsyncLoading(); 
   final supabase = ref.read(supabaseClientProvider);
  
  state= await AsyncValue.guard(
    ()async{
      await supabase.auth.signInWithOtp(email: email);
    });
}


 //SEND OTP TO PHONE Number 
Future<void> sendOtpPhone(String phone) async{
   state = const AsyncLoading(); 
   final supabase = ref.read(supabaseClientProvider);
  
  state= await AsyncValue.guard(
    ()async{
       await supabase.auth.signInWithOtp(phone:phone);
    });
}


Future<void> verifyOtp({
  required String contact,
  required String code,
   required String option,
}) async {
  state = const AsyncLoading();
  final supabase = ref.read(supabaseClientProvider);

  state = await AsyncValue.guard(() async {
    await supabase.auth.verifyOTP(
      email: option == "email" ? contact : null,
       phone: option == "phone" ? contact : null,
      token: code,
    type: option == "email" ? OtpType.email : OtpType.sms,
    );
   
  });
  
}



// UPDATE PASSWORD
Future<void> updatePassword(String newPassword) async {
  state = const AsyncLoading();
  final supabase = ref.read(supabaseClientProvider);

  state = await AsyncValue.guard(() async {
    final response = await supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (response.user == null) {
      throw Exception("Failed to update password");
    }
  });
}

//Update Email

Future<void> updateEmail(String newEmail) async {
  state = const AsyncLoading();
  final supabase = ref.read(supabaseClientProvider);
  state = await AsyncValue.guard(() async {
    final response = await supabase.auth.updateUser(
      UserAttributes(email: newEmail),
    );
    if (response.user == null) {
      throw Exception("Failed to update email");
    }
  });
}


}



  
  final authControllerProvider =
      AsyncNotifierProvider<AuthController, void>(AuthController.new);



