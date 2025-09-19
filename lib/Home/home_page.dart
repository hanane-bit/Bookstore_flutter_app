
import 'package:flutter/material.dart';
import 'package:projet_final/Home/Book_list.dart';

import 'package:projet_final/Home/page_grid.dart';
import 'package:projet_final/Home/wishlist.dart';
import 'package:projet_final/models/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:projet_final/Profile/first_page.dart';

import 'Notifications_page.dart';




class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BooksList()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WishList()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
    }
  }

  void _onSearchTapped() async {
    final books = await ref.read(booksProvider.future);
    showSearch(
      context: context,
      delegate: BookSearchDelegate(books),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //APPBAR
      appBar: AppBar(
       
        backgroundColor: Colors.white,

        leading:  IconButton(
           onPressed: _onSearchTapped,
          icon: Icon(Icons.search, color: Color(0xFF54408C)),
        ),


          title:   Text('Home' , style: TextStyle(color: Colors.black , fontSize: 20 ,  fontWeight: FontWeight.bold),
          ),
          centerTitle: true,

           actions: [
               IconButton(
                onPressed: (){
                   Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsPage()),
      );
                },
                 icon:Icon(Icons.notifications)),
           ],   

      ),

      

      //APPBAR
      body: SafeArea(
        child:Padding(
          padding: EdgeInsets.all(24) ,
          child:  ListView(
            children: [
               SpecialOffersWidget(),
                SizedBox(height: 20),
                TopWeek(),
                SizedBox(height: 20),
                BestVendors(),
            ],
          ),
            
          ),     
    ),
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF54408C),
        unselectedItemColor: Colors.grey,
         type: BottomNavigationBarType.fixed,
        
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
class BookSearchDelegate extends SearchDelegate {
  final List books;

  BookSearchDelegate(this.books);

  @override
  String? get searchFieldLabel => 'Rechercher un livre';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books.where((book) => book.book_title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: Image.network(book.book_image, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(book.book_title),
          subtitle: Text(book.book_price),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books.where((book) => book.book_title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          leading: Image.network(book.book_image, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(book.book_title),
          subtitle: Text(book.book_price),
          onTap: () {
            query = book.book_title;
            showResults(context);
          },
        );
      },
    );
  }
}
 


//Special Offers 
class SpecialOffersWidget extends ConsumerStatefulWidget {
  const SpecialOffersWidget({super.key});

  @override
  ConsumerState<SpecialOffersWidget> createState() => _SpecialOffersWidgetState();
}

class _SpecialOffersWidgetState extends ConsumerState<SpecialOffersWidget> {
   final PageController pageController = PageController();
   double currentPage =0 ; 
   @override
  Widget build(BuildContext context ) {
        final offersAsync = ref.watch(specialOffersProvider);

    return offersAsync.when(
      data: (offers) =>Container( 
        height:180,
        width:327,   
              child: Column(
                children: [
                  Expanded(
                    child:
                    PageView.builder(
                      controller: pageController,
                      
                      itemCount: offers.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage=index.toDouble();
                        });
                        
                      },
                      itemBuilder: (context , index) {
                        final offer=offers[index];
                        return Container (
                         color: Colors.grey.shade100,
                         child:Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           
                           children: [

                              Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Special offer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('Discount ${offer.discount}%'),
                                SizedBox(height:16),
                                 ElevatedButton(
                        onPressed:() {
                       
                        }, 
                         style:ElevatedButton.styleFrom(
                          backgroundColor:Color(0xFF54408C),
                           shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48)),),
                        child: Container(
                          width: 118,
                          height: 36,
                          alignment: Alignment.center,
                          child: Text('Order Now ' , style: TextStyle(color: Colors.white , fontSize: 16)) ,
                           
                        ) ,
                        
                        ),

                                ],


                              ),

                                  Image.network(offer.offer_image , width:99 , height:145) ,
                           ],
                             

                         )


                        );
                      }, 
                                          
                      )
                    
                  ),
                   SizedBox(height: 8),
              DotsIndicator(
              dotsCount: offers.length, 
              position: currentPage,
              decorator: DotsDecorator(
                color:Colors.grey,
                activeColor: Color(0xFF54408C),
                 size: const Size.square(6.0),
                  activeSize: const Size(8.0, 8.0),
                   activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
            ),
              ),),
                ],
              ),
         
      ),
       error:(err, stack) => Text(err.toString()), 
       loading: () => CircularProgressIndicator()
       ) ;
  }
}


// TOP OF THE WEEK WIDGET 
class TopWeek extends ConsumerWidget {
  const TopWeek({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TopWeekAsync = ref.watch(booksProvider);

    return TopWeekAsync.when(
      data: (books) {
        final topBooks =books.where((book)=>book.is_top=="true").toList();
        if (topBooks.isEmpty) {
          return Center(child: Text("Aucun livre disponible"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Of Week',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {
 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  SeeAllPage(
                      title: 'Books',
                      subtitle: 'Our Books',
                      isvendors: false,
                    )),
                      );

                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: Color(0xFF54408C),
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
           
            SizedBox(
              height: 198,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:topBooks.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final book = topBooks[index];
                  return Container(
                    width: 130,
                    margin: EdgeInsets.only(right: 12), 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 127,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200, 
                          ),
                          child: Image.network(
                            book.book_image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.book_title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          book.book_price,
                          style: TextStyle(
                              color: Color(0xFF54408C),
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (err, stack) => Center(child: Text(err.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}



//BEST VENDORS WIDGET 

class BestVendors extends ConsumerWidget {
  const BestVendors({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BestVendorsAsync = ref.watch(vendorsProvider);

    return BestVendorsAsync.when(
      data: (vendors) {
        final Bestvendors =vendors.where((vendor)=>vendor.is_best=="true").toList();
        if (Bestvendors.isEmpty) {
          return Center(child: Text("Aucun livre disponible"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vendors',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {
                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  SeeAllPage(
                      title: 'Vendors',
                      subtitle: 'Our Vendors',
                      isvendors: true,
                    )),
                      );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                        color: Color(0xFF54408C),
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
           
            SizedBox(
              height: 198,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:Bestvendors.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final vendor = Bestvendors[index];
                  return Container(
                    width: 130,
                    margin: EdgeInsets.only(right: 12), 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 127,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Image.network(
                            vendor.vendor_image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vendor.vendor_title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                         Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                                    
                          children: List.generate(
                         5, (index){
                          return Icon(
                        index<vendor.vendor_rating ?
                        Icons.star :Icons.star_border,
                       color:Colors.yellow.shade700,
                       size:16);
                                        })                      
                                      ,),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (err, stack) => Center(child: Text(err.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

