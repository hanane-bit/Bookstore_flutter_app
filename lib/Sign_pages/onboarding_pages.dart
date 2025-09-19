import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'sign_up.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({super.key});

  final PageController page_controller = PageController();
  double page=0 ;
  final List<Map<String, String>> onboardingData = [
  {
    'image': 'assets/Onboarding/Frame.png',
    'title': 'Now reading books will be easier',
    'subtitle': 'Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.',
  },
  {
    'image': 'assets/Onboarding/Frame1.png',
    'title': 'Your Bookish Soulmate Awaits',
    'subtitle': 'Let us be your guide to the perfect read. Discover books tailored to your tastes for a truly rewarding experience.',
  },
  {
    'image': 'assets/Onboarding/Frame2.png',
    'title': 'Start Your Adventure',
    'subtitle': 'Ready to embark on a quest for inspiration and knowledge? Your adventure begins now. Let\'s go!',
  },
];

 

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
backgroundColor: Colors.white,
        body: Column(
          children: [
              Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:55),
                      child: TextButton(
                        onPressed:(){
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SignInPage()),
                                  );
                        } ,
                            child: Text('Skip' , style: TextStyle(color:Color(0xFF54408C), fontSize: 14),)
                          ),
                    ),
                  ),

            SizedBox(
               height: MediaQuery.of(context).size.height * 0.63,
              child: PageView.builder(
                itemCount: widget.onboardingData.length,
              controller:widget.page_controller ,
              onPageChanged: (index){
                setState(() {
                  widget.page=index.toDouble(); 
                }); 
              },
               itemBuilder:(context , index ) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical :16),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(widget.onboardingData[index]['image']!,
                      width: 320,
                     height: 320,),
                     SizedBox(height:24),

                     Text(widget.onboardingData[index]['title']!,
                      style:TextStyle(
                          fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            
                      ),
                        textAlign: TextAlign.center,
                       ), 
                        const SizedBox(height: 16),

                         Text(widget.onboardingData[index]['subtitle']!,
                      style:TextStyle(
                          fontSize: 16,
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.none,
                            
                      ),
                        textAlign: TextAlign.center,
                       ), 


                    ],
                    

                  ),
                  );
               },
              ),
            ),

             DotsIndicator(
              dotsCount: 3, 
              position: widget.page,
              decorator: DotsDecorator(
                color:Colors.grey,
                activeColor: Color(0xFF54408C),
                 size: const Size.square(6.0),
                  activeSize: const Size(8.0, 8.0),
                   activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
            ),
              ),),
                SizedBox(height:24),
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child:Column(
                children: [
                   ElevatedButton(
                  onPressed: (){
                  if (widget.page < 2) {
                      widget.page_controller.nextPage(
                         duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                      );
                  }else if (widget.page ==2) {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );

                  }
                 
                  }, 
                  
                    style:ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFF54408C),
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),),
                              child: 
                  Container(
                    width: 327,
                     height: 56,
                    alignment: Alignment.center ,
                    child: Text(widget.page==1  || widget.page==2? 'Get Started' :'Continue' , style: TextStyle(color: Colors.white , fontSize: 16),
                    
                    )
                    ),
                  
                  ),
                    SizedBox(height: 10),
                
                  ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                      );
                  }, 
                  
                    style:ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFFFAF9FD),
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),),
                              child: 
                  Container(
                    width: 327,
                    height: 56,
                    alignment: Alignment.center ,
                    child: Text('Sign In' , style: TextStyle(color: Color(0xFF54408C) , fontSize: 16),
                    )
                    ),
                  
                  ),
                ],
              )

                ),

          ],
        ),
      );
      
  }
}