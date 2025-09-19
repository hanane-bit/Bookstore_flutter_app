import 'package:flutter/material.dart';


import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Sign_pages/spash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});



void main() async {
   await dotenv.load(fileName: "assets/.env");
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
     url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
 runApp(ProviderScope(
    child: MyApp(),
  ));
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: spashScreen(),
     
    );
  }
}


   
      
      
      
      
      
      
      
   